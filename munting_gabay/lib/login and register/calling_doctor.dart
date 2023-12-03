import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:munting_gabay/variable.dart';

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
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: Text('Make a Phone Call'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Doctor ID: $docId',
              style: TextStyle(fontSize: 18, color: text),
            ),
            Text(
              'Doctor Name: $currentUserName',
              style: TextStyle(fontSize: 18, color: text),
            ),
            Text(
              'Phone Number: $phoneNumber',
              style: TextStyle(fontSize: 18, color: text),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary:
                    BtnColor, // Change this color to the desired background color
              ),
              onPressed: () {
                makePhoneCall(); // Call the function to make a phone call
              },
              child: Text(
                'Call $phoneNumber',
                style: TextStyle(color: text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
