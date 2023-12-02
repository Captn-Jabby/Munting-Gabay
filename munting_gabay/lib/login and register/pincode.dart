import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/screens/parents%20page/Parent_page.dart';
import 'package:munting_gabay/login%20and%20register/forgot_pin.dart';
import 'package:munting_gabay/variable.dart';
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
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
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
            // Inside your PinScreen widget build method:
            ElevatedButton(
              onPressed: () {
                // Navigate to the ForgotPINScreen when the button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewPINScreen()),
                );
              },
              child: Text("Forgot PIN"),
            )
          ],
        ),
      ),
    );
  }

  // getting the Pincode in the firebase (PLEASE ALSO CHECK THE CHANGEPIN_SCREEN)
  void _verifyPin(String pin) async {
    EasyLoading.show(status: 'Verifying PIN...'); // Show loading indicator

    try {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final String currentUserId = user.uid;
        print('Current User ID: $currentUserId'); // Print the current user's ID

        // Retrieve the 'pincode' field for the current user from Firestore using their email
        DocumentSnapshot userData = await FirebaseFirestore.instance
            .collection('usersdata')
            .doc(user.email) // Use the user's email as the document ID
            .get();
        // print('User Data: ${userData.data()}'); // Print the entire user data

        if (userData.exists) {
          final Map<String, dynamic> userDataMap =
              userData.data() as Map<String, dynamic>;
          final String savedPin = userDataMap['pin'];
          // print('Saved PIN: $savedPin'); // Print the saved PIN
          // print('Entered PIN: $pin'); // Print the entered PIN for debugging

          if (pin == savedPin) {
            // Correct PIN, proceed to the next screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ParentPage()),
            );
          } else {
            // Incorrect PIN, show an error message
            EasyLoading.showError('Incorrect PIN. Please try again.');
          }
        } else {
          EasyLoading.showError('User data not found in Firestore.');
        }
      } else {
        EasyLoading.showError('User not authenticated.');
      }
    } catch (e) {
      EasyLoading.showError('Error verifying PIN: $e');
    } finally {
      EasyLoading.dismiss(); // Dismiss loading indicator
    }
  }
}
