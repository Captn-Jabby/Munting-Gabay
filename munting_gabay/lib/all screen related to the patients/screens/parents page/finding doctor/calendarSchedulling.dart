import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';

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
  final DateTime _focusedDay = DateTime.now();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<DateTime> bookedDates = [];

  @override
  void initState() {
    super.initState();
    fetchBookedDates();
  }

  void fetchBookedDates() async {
    try {
      final DocumentSnapshot doc =
          await firestore.collection('usersdata').doc(widget.docId).get();

      if (doc.exists) {
        final List<dynamic> schedule = doc['schedule'];
        final List<DateTime> dates = schedule
            .map((entry) => (entry['sched'] as Timestamp).toDate())
            .toList();

        setState(() {
          bookedDates = dates;
        });
      }
    } catch (e) {
      print('Error fetching booked dates: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar Screen'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TableCalendar(
              focusedDay: _focusedDay,
              firstDay: DateTime(2000),
              lastDay: DateTime(2101),
              onDaySelected: (selectedDate, focusedDay) {
                setState(() {
                  _selectedDate = selectedDate;
                });
              },
              eventLoader: (day) {
                final events = bookedDates
                    .where((date) =>
                        date.year == day.year &&
                        date.month == day.month &&
                        date.day == day.day)
                    .toList();
                return events;
              },
              // Customize the calendar appearance and behavior here
            ),
            if (_selectedDate != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_selectedDate != null) {
                      showConfirmationDialog(_selectedDate!);
                    }
                  },
                  child: const Text('Send Date Request'),
                ),
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
          title: const Text('Confirm Date and Time'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Selected Date and Time:'),
              Text(
                DateFormat('yyyy-MM-dd HH:mm').format(selectedDate),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                sendDateRequestToFirebase(selectedDate);
                Navigator.of(context).pop();
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void sendDateRequestToFirebase(DateTime selectedDate) async {
    try {
      final CollectionReference usersDataCollection =
          firestore.collection('usersdata');
      final User? user = FirebaseAuth.instance.currentUser;

      if (selectedDate != null && user != null) {
        final DocumentReference userDocument =
            usersDataCollection.doc(widget.docId);
        final Timestamp timestamp = Timestamp.fromDate(selectedDate);

        await userDocument.update({
          'schedule': FieldValue.arrayUnion([
            {
              'PatientsId': user.uid,
              'sched': timestamp,
            }
          ]),
        });

        print('Date request sent successfully.');
      } else {
        print('No date selected.');
      }
    } catch (e) {
      print('Error sending date request: $e');
    }
  }
}
