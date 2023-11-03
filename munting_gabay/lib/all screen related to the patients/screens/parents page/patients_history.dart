import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RequestListScreen extends StatefulWidget {
  final String docId;

  RequestListScreen({required this.docId});

  @override
  _RequestListScreenState createState() => _RequestListScreenState();
}

class _RequestListScreenState extends State<RequestListScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  List<Map<String, dynamic>> myRequests = []; // Store both slot and date

  @override
  void initState() {
    super.initState();
    // Load the requests made by the user from Firestore.
    loadMyRequests();
  }

  Future<void> loadMyRequests() async {
    if (user != null) {
      final querySnapshot =
          await firestore.collection('schedule').doc(widget.docId).get();

      if (querySnapshot.exists) {
        final requestData = querySnapshot.data() as Map<String, dynamic>;
        if (requestData.containsKey('available_days')) {
          final requestList = (requestData['available_days'] as List)
              .expand((dayData) => (dayData['slots'] as List)
                      .where((slotData) =>
                          (slotData['patients'] as String) == user?.email)
                      .map((slotData) {
                    return {
                      'slot': slotData['slot'] as String,
                      'date': dayData['date'] as String, // Add the date
                    };
                  }))
              .toList();

          setState(() {
            myRequests = requestList;
          });
        }
      }
    }
  }

  bool isCancelling = false;

  Future<void> _cancelRequest(String requestSlot) async {
    if (isCancelling) {
      return;
    }

    if (user != null) {
      // Set the flag to true to prevent further calls
      isCancelling = true;

      // Get the Firestore document for the specific slot and update it
      final slotDocument = firestore.collection('schedule').doc(widget.docId);

      final snapshot = await slotDocument.get();
      if (snapshot.exists) {
        final requestData = snapshot.data() as Map<String, dynamic>;

        if (requestData.containsKey('available_days')) {
          final availableDays = requestData['available_days'] as List;

          for (var dayData in availableDays) {
            final slots = dayData['slots'] as List;

            final slotToCancel = slots.firstWhere(
              (slotData) => (slotData['slot'] as String) == requestSlot,
              orElse: () => null,
            );

            if (slotToCancel != null) {
              // Check if the slot has 'Pending' status
              if (slotToCancel['status'] == 'Pending') {
                // Update the status to 'Canceled'
                slotToCancel['status'] = 'Canceled';

                // Update the Firestore document
                await slotDocument.update({
                  'available_days': availableDays,
                });

                // Remove the canceled request from the local list
                setState(() {
                  myRequests.remove(requestSlot);
                });

                // Show a confirmation message or handle any other UI updates
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Request canceled for $requestSlot')),
                );
              } else {
                // Handle cases where the slot is not 'Pending' (e.g., it's 'Accepted')
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('You can only cancel pending requests.')),
                );
              }
            }
          }
        }
      }

      // Set the flag back to false
      isCancelling = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Requests'),
      ),
      body: myRequests.isEmpty
          ? Center(
              child: Text('You have not made any requests.'),
            )
          : ListView.builder(
              itemCount: myRequests.length,
              itemBuilder: (context, index) {
                final requestSlot = myRequests[index];
                final slot = requestSlot['slot'] as String;
                final date = requestSlot['date'] as String;

                return ListTile(
                  title: Text('Date: $date, Slot: $slot'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      _cancelRequest(slot);
                    },
                    child: Text('Cancel'),
                  ),
                );
              },
            ),
    );
  }
}
