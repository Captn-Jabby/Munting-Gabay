import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DoctorScheduleScreen extends StatelessWidget {
  final String docId; // Doctor's ID
  User? user = FirebaseAuth.instance.currentUser; // Get the current user

  DoctorScheduleScreen({required this.docId}) {
    print('Accessed DoctorScheduleScreen with docId: $docId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Appointment'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('schedule')
            .doc(docId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Text('No data found for this doctor.'),
            );
          } else {
            var data = snapshot.data!.data() as Map<String, dynamic>;
            var availableDays = data['available_days'] as List<dynamic>;

            // Access and display the data from Firestore
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text('Doctor Name: ${data['doctor_name']}'),
                  Text('Month: ${data['month']}'),
                  Text('Available Days:'),
                  Column(
                    children: availableDays.map<Widget>((day) {
                      var dayData = day as Map<String, dynamic>;
                      return Column(
                        children: <Widget>[
                          Text(dayData['day']),
                          Column(
                            children: dayData['slots'].map<Widget>((slot) {
                              return ListTile(
                                title: Text('Time Slot: $slot'),
                                trailing: ElevatedButton(
                                  onPressed: () {
                                    // Add logic to send a request for the appointment
                                    _requestAppointment(
                                      context,
                                      docId,
                                      data['doctor_name'],
                                      dayData['day'],
                                      slot,
                                      FirebaseFirestore
                                          .instance, // Pass the firestore object here
                                    );
                                  },
                                  child: Text('Request'),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  void _requestAppointment(
      BuildContext context,
      String docId,
      String doctorName,
      String day,
      String timeSlot,
      FirebaseFirestore firestore) {
    print('Requesting appointment for: $doctorName on $day at $timeSlot');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Appointment Request'),
          content: Text(
              'Request an appointment with Dr. $doctorName on $day at $timeSlot?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                try {
                  print('Sending appointment request...');

                  // Add logic to send the appointment request
                  await firestore.collection('schedule').doc(docId).update({
                    'available_days': FieldValue.arrayUnion([
                      {
                        'day': day,
                        'slots': [
                          {'slot': timeSlot, 'status': 'Pending'}
                        ]
                      }
                    ])
                  });

                  print('Appointment request submitted.');

                  // Handle success, e.g., show a confirmation message
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Appointment request submitted.')));
                } catch (error) {
                  print('Error submitting appointment request: $error');

                  // Handle errors, e.g., show an error message
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Error submitting appointment request.')));
                }
                Navigator.of(context).pop();
              },
              child: Text('Request'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // void _requestAppointment(BuildContext context, String docId,
  //     String doctorName, String day, String timeSlot) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text('Appointment Request'),
  //         content: Text(
  //             'Request an appointment with Dr. $doctorName on $day at $timeSlot?'),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () async {
  //               try {
  //                 // Add logic to submit the appointment request
  //                 // You can use FirebaseFirestore to create a new document in the "appointments" collection.
  //                 // Here's an example of how you can do it:
  //                 await FirebaseFirestore.instance
  //                     .collection('appointments')
  //                     .add({
  //                   'doctorId': docId,
  //                   'patientId': FirebaseAuth.instance.currentUser?.uid,
  //                   'day': day,
  //                   'timeSlot': timeSlot,
  //                   'status': 'Pending', // You can set the initial status
  //                 });
  //                 // Handle success, e.g., show a confirmation message
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   SnackBar(content: Text('Appointment request submitted.')),
  //                 );
  //               } catch (error) {
  //                 // Handle errors, e.g., show an error message
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   SnackBar(
  //                       content: Text('Error submitting appointment request.')),
  //                 );
  //               }
  //               Navigator.of(context).pop();
  //             },
  //             child: Text('Request'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: Text('Cancel'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
