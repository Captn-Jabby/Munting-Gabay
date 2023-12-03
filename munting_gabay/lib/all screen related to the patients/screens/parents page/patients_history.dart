import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:munting_gabay/variable.dart';

class RequestListScreen extends StatefulWidget {
  final String docId;

  RequestListScreen({required this.docId});

  @override
  _RequestListScreenState createState() => _RequestListScreenState();
}

class _RequestListScreenState extends State<RequestListScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  List<Map<String, dynamic>> myRequests = [];

  @override
  void initState() {
    super.initState();
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
                      'date': dayData['date'] as String,
                      'status': slotData['status'] as String,
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
      isCancelling = true;

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
              if (slotToCancel['status'] == 'Pending') {
                slotToCancel['status'] = 'Canceled';

                await slotDocument.update({
                  'available_days': availableDays,
                });

                setState(() {
                  myRequests.remove(requestSlot);
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Request canceled for $requestSlot')),
                );
                break; // Exit the loop after a successful cancel
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('You can only cancel pending requests.')),
                );
              }
            }
          }
        }
      }

      isCancelling = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
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
                final status = requestSlot['status'] as String;

                return ListTile(
                  title: Text('Date: $date, Slot: $slot, Status: $status'),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary:
                          BtnColor, // Change this color to the desired background color
                    ),
                    onPressed: () {
                      if (status == 'Pending') {
                        _cancelRequest(slot);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'You can only cancel pending requests.')),
                        );
                      }
                    },
                    child: Text('Cancel'),
                  ),
                );
              },
            ),
    );
  }
}
