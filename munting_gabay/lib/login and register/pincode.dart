import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/screens/parents%20page/Parent_page.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinScreen extends StatefulWidget {
  @override
  _PinScreenState createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  String enteredPin = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter PIN'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PinCodeTextField(
              appContext: context,
              length: 4, // Set the length of the PIN
              onChanged: (value) {
                setState(() {
                  enteredPin = value;
                });
              },
              onCompleted: (value) {
                // Called when the user completes entering the PIN
                _verifyPin(value); // Call the verification method
              },
            ),
            SizedBox(height: 20.0),
            Text(
              'Enter your PIN',
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
  // getting the Pincode in the firebase (PLEASE ALSO CHECK THE CHANGEPIN_SCREEN)
  // void _verifyPin(String pin) async {
  //   EasyLoading.show(status: 'Verifying PIN...'); // Show loading indicator

  //   try {
  //     final User? user = FirebaseAuth.instance.currentUser;

  //     if (user != null) {
  //       final CollectionReference usersDataCollection =
  //           FirebaseFirestore.instance.collection('usersdata');

  //       final String currentUserId = user.uid;

  //       // Retrieve the 'pincode' field for the current user from Firestore
  //       final DocumentSnapshot userData =
  //           await usersDataCollection.doc(currentUserId).get();

  //       if (userData.exists) {
  //         final String savedPin = userData['pincode'];

  //         if (pin == savedPin) {
  //           // Correct PIN, proceed to the next screen
  //           Navigator.pushReplacement(
  //             context,
  //             MaterialPageRoute(builder: (context) => ParentPage()),
  //           );
  //         } else {
  //           // Incorrect PIN, show an error message
  //           EasyLoading.showError('Incorrect PIN. Please try again.');
  //         }
  //       } else {
  //         EasyLoading.showError('User data not found in Firestore.');
  //       }
  //     } else {
  //       EasyLoading.showError('User not authenticated.');
  //     }
  //   } catch (e) {
  //     EasyLoading.showError('Error verifying PIN: $e');
  //   } finally {
  //     EasyLoading.dismiss(); // Dismiss loading indicator
  //   }
  // }
  void _verifyPin(String pin) async {
    EasyLoading.show(status: 'Verifying PIN...'); // Show loading indicator

    // Simulate asynchronous verification (replace with actual logic)
    await Future.delayed(Duration(seconds: 2));

    EasyLoading.dismiss(); // Dismiss loading indicator

    if (pin == '1234') {
      // Replace '1234' with your actual PIN
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ParentPage()),
      );
    } else {
      // Incorrect PIN, show an error message
      EasyLoading.showError('Incorrect PIN. Please try again.');
    }
  }
}
