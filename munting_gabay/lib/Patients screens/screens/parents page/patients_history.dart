import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _schedulesCollection =
      FirebaseFirestore.instance.collection('usersdata');

  @override
  void initState() {
    super.initState();
    // Call the function to check user schedules when this screen is loaded
    checkUserSchedules();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: FutureBuilder(
        future: _fetchUserSchedules(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No history available.'));
          } else {
            // Display the retrieved schedules here, for example, in a ListView
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                final schedule = snapshot.data?[index];
                final DateTime schedDateTime = schedule?['sched'].toDate();
                final String formattedDateTime =
                    DateFormat('yyyy-MM-dd HH:mm').format(schedDateTime);
                return ListTile(
                  title: Text('Scheduled Date and Time: $formattedDateTime'),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<DocumentSnapshot>> _fetchUserSchedules() async {
    final User? user = _auth.currentUser;

    if (user != null) {
      final String currentUserId = user.uid;
      print('Current User ID: $currentUserId'); // Debugging: Print user's UID
      final querySnapshot = await _schedulesCollection
          .where('DoctorId', isEqualTo: currentUserId) // Change to DoctorId
          .get();

      print(
          'Query Result: ${querySnapshot.docs}'); // Debugging: Print query result

      return querySnapshot.docs;
    }

    return [];
  }

  Future<void> checkUserSchedules() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final String currentUserId = user.uid;
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('usersdata')
          .doc(currentUserId)
          .get();

      if (userDoc.exists) {
        final List<dynamic> schedules = userDoc['schedule'];
        if (schedules.isNotEmpty) {
          // User has schedules, you can process them here
          print('User has schedules: $schedules');
        } else {
          // User has no schedules
          print('User has no schedules.');
        }
      } else {
        // User document doesn't exist
        print('User document does not exist.');
      }
    }
  }
}
