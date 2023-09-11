import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../drawer_page.dart';
import '../variable.dart';

class DoctorDetailsScreen extends StatefulWidget {
  final String docId;
  final String initialName;
  final String initialAddress;
  final String initialAge;
  final String initialStatus;

  DoctorDetailsScreen({
    required this.docId,
    required this.initialName,
    required this.initialAddress,
    required this.initialAge,
    required this.initialStatus,
  });

  @override
  _DoctorDetailsScreenState createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  late String currentStatus;
  late String selectedStatus;

  @override
  void initState() {
    super.initState();
    currentStatus = widget.initialStatus;
    selectedStatus = widget.initialStatus;
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
            SizedBox(
              height: BtnSpacing,
            ),
            Text('Doctor ID: ${widget.docId}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text('Name: ${widget.initialName}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text('Address: ${widget.initialAddress}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text('Age: ${widget.initialAge}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text('Status:', style: TextStyle(fontSize: 16)),
            Row(
              children: [
                Radio(
                  value: 'Accepted',
                  groupValue: selectedStatus,
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value.toString();
                    });
                  },
                ),
                Text('Accepted'),
                Radio(
                  value: 'Denied',
                  groupValue: selectedStatus,
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value.toString();
                    });
                  },
                ),
                Text('Denied'),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                // Update the status in Firestore
                FirebaseFirestore.instance
                    .collection('usersdata')
                    .doc(widget.docId)
                    .update({
                  'status': selectedStatus,
                }).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Status updated!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to update status.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                });
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
