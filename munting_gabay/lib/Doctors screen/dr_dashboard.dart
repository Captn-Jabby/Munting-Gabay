import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:munting_gabay/Doctors%20screen/Dr_drawer.dart';
import 'package:munting_gabay/Dr_Profile.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/screens/parents%20page/finding%20doctor/MessagePage.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/screens/parents%20page/finding%20doctor/message_screen.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/screens/parents%20page/finding%20doctor/userpage.dart';
import 'package:munting_gabay/drawer_page.dart';
import 'package:munting_gabay/variable.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DocDashboard extends StatefulWidget {
  @override
  _DocDashboardState createState() => _DocDashboardState();
}

class _DocDashboardState extends State<DocDashboard> {
  DateTime? _selectedDate;
  DateTime _focusedDay = DateTime.now(); // Provide the initial focused day
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<DateTime> bookedDates = [];

  @override
  void initState() {
    super.initState();
    // Fetch the booked dates for the current doctor
    fetchBookedDates();
  }

  void fetchBookedDates() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final CollectionReference usersDataCollection =
            firestore.collection('usersdata');

        final DocumentSnapshot doc =
            await usersDataCollection.doc(user.uid).get();
        print('Current User UID: ${user.uid}');
        if (doc.exists) {
          final List<dynamic> schedule = doc['schedule'];

          // Create a list to store the scheduled dates
          List<DateTime> dates = [];

          // Extract the sched from the document
          schedule.forEach((entry) {
            final DateTime sched = (entry['sched'] as Timestamp).toDate();
            dates.add(sched);
          });

          setState(() {
            bookedDates = dates;
          });
        }
      }
    } catch (e) {
      // Handle errors here
      print('Error fetching booked dates: $e');
    }
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
          IconButton(
            icon: Icon(Icons.message),
            onPressed: () {
              // Handle the action when the message button is pressed
              // For example, navigate to the chat screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserSelectionPage()
                    // ReceiverChatPage(receiverId: '', receiverName: '',)

                    ),
              );
            },
          ),
        ],
      ),
      drawer: DrDrawer(),
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
            if (bookedDates
                .isNotEmpty) // Only display if there are booked dates
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Booked Dates:',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Column(
                    children: bookedDates.map((date) {
                      // Format the date as you desire, e.g., 'yyyy-MM-dd'
                      final formattedDate =
                          DateFormat('yyyy-MM-dd').format(date);
                      return Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
