import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
                  Text('Available Days:'),
                  Column(
                    children: availableDays.map<Widget>((day) {
                      var dayData = day as Map<String, dynamic>;
                      return DayCard(dayData: dayData, docId: docId);
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
}

class DayCard extends StatefulWidget {
  final Map<String, dynamic> dayData; // Change this to dynamic
  final String docId;

  DayCard({required this.dayData, required this.docId});

  @override
  _DayCardState createState() => _DayCardState();
}

class _DayCardState extends State<DayCard> {
  bool slotsVisible = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('Day: ${widget.dayData['day']}'),
            subtitle:
                Text('Date: ${widget.dayData['date']}'), // Display the date
            trailing: ElevatedButton(
              onPressed: () {
                setState(() {
                  slotsVisible = !slotsVisible;
                });
              },
              child: Text(slotsVisible ? 'Hide Slots' : 'Show Slots'),
            ),
          ),
          if (slotsVisible)
            Column(
              children: (widget.dayData['slots'] as List<dynamic>)
                  .map<Widget>((slot) {
                return SlotTile(
                  slotData: slot as Map<String, dynamic>,
                  docId: widget.docId,
                  day: widget.dayData['day'] as String,
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

class SlotTile extends StatefulWidget {
  final Map<String, dynamic> slotData;
  final String docId;
  final String day;

  SlotTile({
    required this.slotData,
    required this.docId,
    required this.day,
  });

  @override
  _SlotTileState createState() => _SlotTileState();
}

class _SlotTileState extends State<SlotTile> {
  bool requesting = false;

  @override
  Widget build(BuildContext context) {
    if (widget.slotData['status'] == 'Available') {
      return ListTile(
        title: Text('Time Slot: ${widget.slotData['slot']}'),
        trailing: ElevatedButton(
          onPressed: () {
            setState(() {
              requesting = true;
            });
            _requestAppointment(widget.day, widget.slotData['slot'] as String);
          },
          child: Text(requesting ? 'Requesting...' : 'Request'),
        ),
      );
    } else {
      return Container(); // Do not display non-available slots
    }
  }

  void _requestAppointment(String day, String timeSlot) {
    User? user = FirebaseAuth.instance.currentUser;
    print('Requesting appointment for: $day at $timeSlot');

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Create a reference to the day within the document
    DocumentReference dayRef =
        firestore.collection('schedule').doc(widget.docId);

    // Get the existing day data
    dayRef.get().then((daySnapshot) {
      if (daySnapshot.exists) {
        Map<String, dynamic> dayData =
            daySnapshot.data() as Map<String, dynamic>;

        // Find the day with the matching 'day' field
        var selectedDay = dayData['available_days'].firstWhere(
          (dayEntry) => dayEntry['day'] == day,
          orElse: () => null,
        );

        if (selectedDay != null) {
          // Update the Firestore document directly by removing the old slot and adding the updated slot
          List<dynamic> slots = List.from(selectedDay['slots']);
          int slotIndex =
              slots.indexWhere((slotEntry) => slotEntry['slot'] == timeSlot);

          if (slotIndex != -1) {
            // Update the status and add the user's email
            slots[slotIndex]['status'] = 'Pending';
            slots[slotIndex]['patients'] = user?.email;

            // Update the slot in the list
            dayData['available_days']
                    [dayData['available_days'].indexOf(selectedDay)]['slots'] =
                slots;

            // Update the Firestore document with the modified day data
            dayRef.update({
              'available_days': dayData['available_days'],
            }).then((_) {
              print('Appointment request submitted.');
              setState(() {
                requesting = false;
              });

              // Handle success, e.g., show a confirmation message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Appointment request submitted.')),
              );
            }).catchError((error) {
              print('Error submitting appointment request: $error');
              setState(() {
                requesting = false;
              });

              // Handle errors, e.g., show an error message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error submitting appointment request.'),
                ),
              );
            });
          }
        }
      }
    });
  }
}
