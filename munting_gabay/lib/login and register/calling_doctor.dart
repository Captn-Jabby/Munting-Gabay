import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class PhoneCallScreen extends StatelessWidget {
  final String phoneNumber; // The phone number you want to call
  final String docId;
  final String currentUserName;

  PhoneCallScreen({
    required this.phoneNumber,
    required this.docId,
    required this.currentUserName,
  });

  void makePhoneCall() async {
    bool? res = await FlutterPhoneDirectCaller.callNumber(phoneNumber);
    if (res != null) {
      if (res) {
        print('Phone call successful');
      } else {
        print('Error making the phone call');
      }
    } else {
      print('Error making the phone call: result is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Make a Phone Call'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Doctor ID: $docId',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Doctor Name: $currentUserName',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Phone Number: $phoneNumber',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                makePhoneCall(); // Call the function to make a phone call
              },
              child: Text('Call $phoneNumber'),
            ),
          ],
        ),
      ),
    );
  }
}
