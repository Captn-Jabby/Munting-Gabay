import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/screens/parents%20page/finding%20doctor/MessagePage.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/screens/parents%20page/finding%20doctor/calendarSchedulling.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/screens/parents%20page/patients_history.dart';
import 'package:munting_gabay/drawer_page.dart';
import 'package:munting_gabay/variable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DoctorInfoPage extends StatefulWidget {
  final String docId;
  final String initialName;
  final String initialAddress;

  DoctorInfoPage({
    required this.docId,
    required this.initialName,
    required this.initialAddress,
  });

  @override
  _DoctorInfoPageState createState() => _DoctorInfoPageState();
}

class _DoctorInfoPageState extends State<DoctorInfoPage> {
  final TextEditingController _dateRequestController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: scaffoldBgColor,
        elevation: 0,
        toolbarHeight: 150,
        iconTheme: IconThemeData(color: BtnColor),
        actions: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/A.png', // Replace with the path to your first image
                  width: 130,
                  height: 150,
                ),
                SizedBox(width: 60), // Add spacing between images
                Image.asset(
                  'assets/LOGO.png',
                  height: 150,
                  width: 130,
                ),
                SizedBox(width: 40),
              ],
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DOCTORS INFORMATION',
              style: buttonTextStyle,
            ),
            Divider(
              color: Colors.black,
              thickness: 2.0,
            ),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly, // Adjust alignment as needed
              children: [
                IconButton(
                  icon: Icon(Icons.calendar_month_rounded), // Scheduling icon
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CalendarScreen(
                          docId: widget.docId,
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.message), // Messaging icon
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          doctorId: widget.docId,
                          doctorName: widget.initialName,
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.call), // Calling icon
                  onPressed: () {
                    // Add functionality for calling here
                  },
                ),
                IconButton(
                  icon: Icon(Icons.lock_clock), // Calling icon
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HistoryScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(
              height: BtnSpacing,
            ),
            Text('Doctor Email: ${widget.docId}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text('Name: ${widget.initialName}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text('Address: ${widget.initialAddress}',
                style: TextStyle(fontSize: 16)),
            SizedBox(
              height: BtnSpacing,
            ),
            Text(
              'Send Date Request',
              style: buttonTextStyle,
            ),
            Divider(
              color: Colors.black,
              thickness: 2.0,
            ),
            // Create a text field for entering the date request
            ElevatedButton(
              onPressed: () async {
                // Show date picker to select the date
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(DateTime.now().year + 1),
                );

                if (selectedDate != null) {
                  // Show time picker to select the time
                  final selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (selectedTime != null) {
                    // Combine selected date and time
                    final selectedDateTime = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    );

                    final formattedDateTime =
                        DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime);

                    _dateRequestController.text = formattedDateTime;

                    // Show the confirmation dialog
                    await showConfirmationDialog(selectedDateTime);
                  }
                }
              },
              child: Text('Select Date and Time'),
            ),

            SizedBox(height: BtnSpacing),
            // Button to send the date request
            // Button to send the date request
            // ElevatedButton(
            //   onPressed: () async {
            //     // Extract the date request text from the controller
            //     final selectedDateText = _dateRequestController.text;
            //     if (selectedDateText.isNotEmpty) {
            //       final selectedDate = DateTime.parse(selectedDateText);

            //       // Check if the same patient has a schedule on the same day
            //       final hasSchedule = await hasScheduleOnSameDay(selectedDate);

            //       if (!hasSchedule) {
            //         // No schedule exists, proceed to send the request
            //         sendDateRequestToFirebase(selectedDate);
            //       } else {
            //         // A schedule already exists for the same patient on the same day
            //         print('You already have a schedule on this day.');
            //       }
            //     } else {
            //       // Handle the case where no date is selected
            //       print('No date selected.');
            //     }
            //   },
            //   child: Text('Send Request'),
            // ),

            SizedBox(height: BtnSpacing),
          ],
        ),
      ),
    );
  }

  Future<void> showConfirmationDialog(DateTime selectedDateTime) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Date and Time'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Selected Date and Time:'),
              Text(
                DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Call the method to send the date request here
                sendDateRequestToFirebase(selectedDateTime);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void sendDateRequestToFirebase(DateTime selectedDate) async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;

      if (selectedDate != null && user != null) {
        // Replace 'usersdata' with your Firestore collection name
        final CollectionReference usersDataCollection =
            FirebaseFirestore.instance.collection('usersdata');

        final String currentUserId = user.uid;

        // Create DocumentReferences for the doctor and current user
        final DocumentReference doctorDocument =
            usersDataCollection.doc(widget.docId);
        final DocumentReference currentUserDocument =
            usersDataCollection.doc(currentUserId);

        // Create a Timestamp object from the selected date
        final Timestamp timestamp = Timestamp.fromDate(selectedDate);

        // Update the 'schedule' field within the doctor's document (widget.docId)
        await doctorDocument.update({
          'schedule': FieldValue.arrayUnion([
            {
              'PatientsId': user.uid,
              'sched': timestamp, // Store the timestamp
            }
          ]),
          // 'PatientsSchedule': FieldValue.arrayUnion([
          //   {
          //     'DocID': widget.docId,
          //     'sched': timestamp, // Store the timestamp
          //   }
          // ]),
        });
        //Needto fix
        // // Update the 'schedule' field within the current user's document (current user's UID)
        // await currentUserDocument.update({
        //   'schedule': FieldValue.arrayUnion([
        //     {
        //       'PatientsId': user.uid,
        //       'sched': timestamp, // Store the timestamp
        //     }
        //   ]),
        //   'PatientsSchedule': FieldValue.arrayUnion([
        //     {
        //       'DocID': widget.docId,
        //       'sched': timestamp, // Store the timestamp
        //     }
        //   ]),
        // });

        print('Date request sent successfully.');
      } else {
        print('No date selected or user not authenticated.');
      }
    } catch (e) {
      // Handle errors here
      print('Error sending date request: $e');
    }
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Future<bool> hasScheduleOnSameDay(DateTime selectedDate) async {
    try {
      final CollectionReference schedulesCollection =
          FirebaseFirestore.instance.collection('usersdata');

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final String patientId = user.uid;

        final DateTime selectedDateStart = DateTime(
            selectedDate.year, selectedDate.month, selectedDate.day, 0, 0);
        final DateTime selectedDateEnd = DateTime(
            selectedDate.year, selectedDate.month, selectedDate.day, 23, 59);

        final querySnapshot = await schedulesCollection
            .where('PatientsId', isEqualTo: patientId)
            .where('sched', isGreaterThanOrEqualTo: selectedDateStart)
            .where('sched', isLessThanOrEqualTo: selectedDateEnd)
            .get();

        // Check if there are any documents in the query result (schedule exists)
        if (querySnapshot.docs.isNotEmpty) {
          return true; // Schedule already exists for the same day
        }
      }
      return false; // Default to false if the user is not authenticated or no schedule found
    } catch (error) {
      // Handle any errors that occur during the query
      print('Error checking schedule: $error');
      return false;
    }
  }
}
