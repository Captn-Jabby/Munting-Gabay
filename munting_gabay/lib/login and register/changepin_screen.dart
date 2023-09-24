import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePin extends StatefulWidget {
  const ChangePin({Key? key});

  @override
  _ChangePinState createState() => _ChangePinState();
}

class _ChangePinState extends State<ChangePin> {
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

        final String? currentUserEmail = user.email;

        // Update the 'pin' field for the current user using their email
        await usersDataCollection.doc(currentUserEmail).update({
          'pin': pin,
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
    try {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final CollectionReference usersDataCollection =
            FirebaseFirestore.instance.collection('usersdata');

        final String? currentUserEmail = user.email;

        // Retrieve the 'pin' field for the current user from Firestore using their email
        final DocumentSnapshot userData =
            await usersDataCollection.doc(currentUserEmail).get();

        if (userData.exists) {
          final Map<String, dynamic> userDataMap =
              userData.data() as Map<String, dynamic>;
          final String savedPin = userDataMap['pin'];

          // Compare the entered current PIN with the saved PIN
          if (currentPin == savedPin) {
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
        } else {
          print('User data not found in Firestore.');
        }
      } else {
        print('User not authenticated.');
      }
    } catch (e) {
      print('Error changing PIN: $e');
    }
  }
}
