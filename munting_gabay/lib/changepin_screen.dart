import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChnagePin extends StatefulWidget {
  const ChnagePin({super.key});

  @override
  State<ChnagePin> createState() => _ChnagePinState();
}

class _ChnagePinState extends State<ChnagePin> {
  String currentPin = '';
  String newPin = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change PIN'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Text fields for current PIN and new PIN
            TextField(
              onChanged: (value) {
                setState(() {
                  currentPin = value;
                });
              },
              obscureText: true, // Hide the PIN input
              decoration: InputDecoration(
                labelText: 'Current PIN',
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              onChanged: (value) {
                setState(() {
                  newPin = value;
                });
              },
              obscureText: true, // Hide the PIN input
              decoration: InputDecoration(
                labelText: 'New PIN',
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Validate the current PIN and change it to the new one
                changePin(currentPin, newPin);
              },
              child: Text('Change PIN'),
            ),
          ],
        ),
      ),
    );
  }

  // Function to set the new PIN in Firestore
  Future<void> setPinInFirestore(String pin) async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final CollectionReference usersDataCollection =
            FirebaseFirestore.instance.collection('usersdata');

        final String currentUserId = user.uid;

        // Update the 'pincode' field for the current user
        await usersDataCollection.doc(currentUserId).update({
          'pincode': pin,
        });

        print('PIN code set successfully in Firestore.');
      } else {
        print('User not authenticated.');
      }
    } catch (e) {
      print('Error setting PIN in Firestore: $e');
    }
  }

  // Function to change the PIN
  void changePin(String currentPin, String newPin) async {
    // Implement your logic to verify the current PIN and change it to the new one
    if (currentPin == '1234') {
      // Replace '1234' with your actual PIN or retrieve it from Firebase
      // Save the new PIN in Firebase
      await setPinInFirestore(newPin);

      // Navigate back to the previous screen or show a success message
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PIN changed successfully.'),
        ),
      );
    } else {
      // Incorrect current PIN, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Incorrect current PIN. Please try again.'),
        ),
      );
    }
  }
}
