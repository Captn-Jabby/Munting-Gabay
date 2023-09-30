import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:munting_gabay/variable.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarScreen extends StatefulWidget {
  final String docId;

  CalendarScreen({
    required this.docId,
  });

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime? _selectedDate;
  DateTime _focusedDay = DateTime.now(); // Provide the initial focused day
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<DateTime> bookedDates = [];

  @override
  void initState() {
    super.initState();
    // Fetch the booked dates for the specified doctor
    fetchBookedDates();
  }

  void fetchBookedDates() async {
    try {
      final CollectionReference usersDataCollection =
          firestore.collection('usersdata');

      final DocumentSnapshot doc =
          await usersDataCollection.doc(widget.docId).get();

      if (doc.exists) {
        final List<dynamic> schedule = doc['schedule'];

        // Extract the scheduled dates from the document
        final List<DateTime> dates = schedule
            .map((entry) => (entry['sched'] as Timestamp).toDate())
            .toList();

        setState(() {
          bookedDates = dates;
        });
      }
    } catch (e) {
      // Handle errors here
      print('Error fetching booked dates: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar Screen'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TableCalendar(
              focusedDay: _focusedDay, // Set the focused day
              firstDay: DateTime(2000), // Replace with your desired range
              lastDay: DateTime(2101), // Replace with your desired range
              onDaySelected: (selectedDate, focusedDay) {
                setState(() {
                  _selectedDate = selectedDate;
                });
              },
              // Customize the calendar appearance and behavior here
            ),
            if (_selectedDate != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_selectedDate != null) {
                      // Send the request to Firebase
                      // sendDateRequestToFirebase(_selectedDate!);
                      // showConfirmationDialog(_selectedDate!);
                    }
                  },
                  child: Text('Send Date Request'),
                ),
              ),
            if (bookedDates.isNotEmpty)
              Column(
                children: [
                  Text(
                    'Booked Dates: ',
                    style: ParentbuttonTextStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      ' ${bookedDates.map((date) => DateFormat('yyyy-MM-dd').format(date)).join(', \n')}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Future<void> showConfirmationDialog(DateTime selectedDate) async {
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
                DateFormat('yyyy-MM-dd HH:mm').format(selectedDate),
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
                sendDateRequestToFirebase(selectedDate);
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
      // Replace 'usersdata' with your Firestore collection name
      final CollectionReference usersDataCollection =
          firestore.collection('usersdata');

      // Replace '123456' with the actual patient's ID
      final User? user = FirebaseAuth.instance.currentUser;

      if (selectedDate != null) {
        // Replace 'document_id' with the ID of the specific document in 'usersdata'
        final DocumentReference userDocument =
            usersDataCollection.doc(widget.docId);

        // Create a Timestamp object from the selected date
        final Timestamp timestamp = Timestamp.fromDate(selectedDate);
        final User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final String patientId = user.uid;
          // Now, you can use `patientId` in your `requestData`.
          // Update the 'schedule' field within the document
          await userDocument.update({
            'schedule': FieldValue.arrayUnion([
              {
                'PatientsId': patientId,
                'sched': timestamp, // Store the timestamp
              }
            ]),
          });
        }
        // Show a success message or perform any other actions upon success
        print('Date request sent successfully.');
      } else {
        print('No date selected.');
      }
    } catch (e) {
      // Handle errors here
      print('Error sending date request: $e');
    }
  }
}
