import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:munting_gabay/Doctors%20screen/schedule_trial.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/screens/parents%20page/finding%20doctor/MessagePage.dart';

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
        iconTheme: const IconThemeData(color: BtnColor),
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
                const SizedBox(width: 60), // Add spacing between images
                Image.asset(
                  'assets/LOGO.png',
                  height: 150,
                  width: 130,
                ),
                const SizedBox(width: 40),
              ],
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'DOCTORS INFORMATION',
              style: buttonTextStyle,
            ),
            const Divider(
              color: Colors.black,
              thickness: 2.0,
            ),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly, // Adjust alignment as needed
              children: [
                IconButton(
                  icon: const Icon(
                      Icons.calendar_month_rounded), // Scheduling icon
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DoctorScheduleScreen(
                          docId: widget.docId,
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.message), // Messaging icon
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
                  icon: const Icon(Icons.call), // Calling icon
                  onPressed: () {
                    // Add functionality for calling here
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.lock_clock), // Calling icon
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
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text('Name: ${widget.initialName}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Text('Address: ${widget.initialAddress}',
                style: const TextStyle(fontSize: 16)),
            SizedBox(
              height: BtnSpacing,
            ),
            const Text(
              'Send Date Request',
              style: buttonTextStyle,
            ),
            const Divider(
              color: Colors.black,
              thickness: 2.0,
            ),
            // Create a text field for entering the date request
            ElevatedButton(
              onPressed: () async {},
              child: const Text('Select Date and Time'),
            ),

            SizedBox(height: BtnSpacing),

            SizedBox(height: BtnSpacing),
          ],
        ),
      ),
    );
  }
}
