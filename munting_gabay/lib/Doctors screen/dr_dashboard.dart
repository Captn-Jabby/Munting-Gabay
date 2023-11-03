import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:munting_gabay/Doctors%20screen/Dr_drawer.dart';
import 'package:munting_gabay/Doctors%20screen/newsched.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/screens/parents%20page/finding%20doctor/userpage.dart';

class DocDashboard extends StatelessWidget {
  final String docId; // Doctor's ID
  User? user = FirebaseAuth.instance.currentUser; // Get the current user

  DocDashboard({required this.docId}) {
    print('Accessed DocDashboard with docId: $docId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Appointment'),
        actions: [
          IconButton(
            icon: Icon(Icons.message),
            onPressed: () {
              // Handle the action when the message button is pressed
              // For example, navigate to the chat screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserSelectionPage()

                    // ConversationList(  currentUserEmail: currentUserEmail ?? ''),
                    ),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.calendar_month,
              color: Colors.indigo,
            ),
            onPressed: () {
              // Handle the action when the message button is pressed
              // For example, navigate to the chat screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DateListScreen()),
                // MaterialPageRoute(builder: (context) => ScheduleScreen()),
              );
            },
          ),
        ],
      ),
      drawer: DrDrawer(),
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
                  Text('Doctor Name:  $docId'),
                  Text('Available Days:'),
                  Column(
                    children: availableDays.map<Widget>((day) {
                      var dayData = day as Map<String, dynamic>;
                      return DayCardDOC(dayData: dayData, docId: docId);
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

class DayCardDOC extends StatefulWidget {
  final Map<String, dynamic> dayData; // Change this to dynamic
  final String docId;

  DayCardDOC({required this.dayData, required this.docId});

  @override
  _DayCardDOCState createState() => _DayCardDOCState();
}

class _DayCardDOCState extends State<DayCardDOC> {
  bool slotsVisible = false;

  @override
  Widget build(BuildContext context) {
    // Check if there are slots with 'Pending' status
    bool hasPendingSlots =
        (widget.dayData['slots'] as List<dynamic>).any((slot) {
      return (slot as Map<String, dynamic>)['status'] == 'Pending';
    });

    if (!hasPendingSlots) {
      return SizedBox
          .shrink(); // Hide the entire card if there are no pending slots
    }

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
              children:
                  (widget.dayData['slots'] as List<dynamic>).where((slot) {
                return (slot as Map<String, dynamic>)['status'] == 'Pending';
              }).map<Widget>((slot) {
                return SlotTileDOC(
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

class SlotTileDOC extends StatefulWidget {
  final Map<String, dynamic> slotData;
  final String docId;
  final String day;

  SlotTileDOC({
    required this.slotData,
    required this.docId,
    required this.day,
  });

  @override
  _SlotTileDOCState createState() => _SlotTileDOCState();
}

class _SlotTileDOCState extends State<SlotTileDOC> {
  bool Accepting = false;

  @override
  Widget build(BuildContext context) {
    if (widget.slotData['status'] == 'Pending') {
      String patientName = widget.slotData['patients'] as String;

      return ListTile(
        title: Text('Time Slot: ${widget.slotData['slot']}'),
        subtitle: Text('Patient: $patientName'),
        trailing: ElevatedButton(
          onPressed: () {
            setState(() {
              Accepting = true;
            });
            _requestAppointment(widget.day, widget.slotData['slot'] as String);
          },
          child: Text(Accepting ? 'Accepting...' : 'Accepted'),
        ),
      );
    } else {
      return Container(); // Do not display non-available slots
    }
  }

  // ... The rest of your code remains the same

  void _requestAppointment(String day, String timeSlot) {
    User? user = FirebaseAuth.instance.currentUser;
    print('Accepting appointment for: $day at $timeSlot');

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
            slots[slotIndex]['status'] = 'Accepted';

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
                Accepting = false;
              });

              // Handle success, e.g., show a confirmation message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Appointment request submitted.')),
              );
            }).catchError((error) {
              print('Error submitting appointment request: $error');
              setState(() {
                Accepting = false;
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
