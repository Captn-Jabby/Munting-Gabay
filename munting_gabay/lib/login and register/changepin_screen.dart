import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/homepage_PT.dart';
import 'package:munting_gabay/variable.dart';

class ChangePin extends StatefulWidget {
  const ChangePin({Key? key});

  @override
  _ChangePinState createState() => _ChangePinState();
}

class _ChangePinState extends State<ChangePin> {
  String currentPin = '';
  String newPin = '';
  bool pinEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: scaffoldBgColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomepagePT(),
              ),
            );
          },
        ),
        title: Text('Change PIN'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              onChanged: (value) {
                setState(() {
                  currentPin = value;
                });
              },
              obscureText: true,
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
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New PIN',
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('PIN Enabled'),
                Switch(
                  value: pinEnabled,
                  onChanged: (value) {
                    setState(() {
                      pinEnabled = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary:
                    BtnColor, // Change this color to the desired background color
              ),
              onPressed: () {
                if (currentPin.isNotEmpty && newPin.isNotEmpty) {
                  changePin(currentPin, newPin);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please fill in both current and new PIN.'),
                    ),
                  );
                }
              },
              child: Text('Change PIN'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary:
                    BtnColor, // Change this color to the desired background color
              ),
              onPressed: () {
                // Update only the pinStatus in Firestore
                updatePinStatusInFirestore(pinEnabled);
              },
              child: Text('Update PIN Status'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> setPinInFirestore(String pin) async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final CollectionReference usersDataCollection =
            FirebaseFirestore.instance.collection('usersdata');

        final String? currentUserEmail = user.email;

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

  Future<void> updatePinStatusInFirestore(bool pinStatus) async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final CollectionReference usersDataCollection =
            FirebaseFirestore.instance.collection('usersdata');

        final String? currentUserEmail = user.email;

        await usersDataCollection.doc(currentUserEmail).update({
          'pinStatus': pinStatus,
        });

        print('PIN status updated successfully in Firestore.');
      } else {
        print('User not authenticated.');
      }
    } catch (e) {
      print('Error updating PIN status in Firestore: $e');
    }
  }

  void changePin(String currentPin, String newPin) async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final CollectionReference usersDataCollection =
            FirebaseFirestore.instance.collection('usersdata');

        final String? currentUserEmail = user.email;

        final DocumentSnapshot userData =
            await usersDataCollection.doc(currentUserEmail).get();

        if (userData.exists) {
          final Map<String, dynamic> userDataMap =
              userData.data() as Map<String, dynamic>;
          final String savedPin = userDataMap['pin'];

          if (currentPin == savedPin) {
            await setPinInFirestore(newPin);

            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('PIN changed successfully.'),
              ),
            );
          } else {
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
