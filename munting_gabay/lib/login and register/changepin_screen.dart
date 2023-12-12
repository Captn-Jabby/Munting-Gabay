import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
  void initState() {
    super.initState();
    fetchPinStatus(); // Fetch PIN status when the widget initializes
  }

  Future<void> fetchPinStatus() async {
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
          final bool savedPinStatus = userDataMap['pinStatus'];

          setState(() {
            pinEnabled = savedPinStatus; // Update the pinEnabled state
          });
        } else {
          print('User data not found in Firestore.');
        }
      } else {
        print('User not authenticated.');
      }
    } catch (e) {
      print('Error fetching PIN status: $e');
    }
  }

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
                GestureDetector(
                  onTap: () {
                    setState(() {
                      pinEnabled = !pinEnabled;
                      updatePinStatusInFirestore(pinEnabled);
                    });
                  },
                  child: Text(pinEnabled ? 'PIN Disabled' : 'PIN Enabled'),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      pinEnabled = !pinEnabled;
                      updatePinStatusInFirestore(pinEnabled);
                    });
                  },
                  child: Container(
                    width: 50, // Adjust width as needed
                    height: 30, // Adjust height as needed
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          15), // Adjust border radius as needed
                      color: pinEnabled
                          ? Colors.grey
                          : Colors.green, // Adjust colors as needed
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          pinEnabled ? 'OFF' : 'ON',
                          style: TextStyle(
                            color: Colors.white, // Adjust text color as needed
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary:
                    secondaryColor, // Change this color to the desired background color
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
              child: Text(
                'Change PIN',
                style: TextStyle(color: text),
              ),
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
    EasyLoading.show(status: 'Loading');
    try {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null && mounted) {
        final CollectionReference usersDataCollection =
            FirebaseFirestore.instance.collection('usersdata');

        final String? currentUserEmail = user.email;

        await usersDataCollection.doc(currentUserEmail).update({
          'pinStatus': pinStatus,
        });

        // Update the local state only if the widget is still mounted
        if (mounted) {
          setState(() {
            pinEnabled = pinStatus;
          });

          EasyLoading.dismiss();
        }

        print('PIN status updated successfully in Firestore.');
      } else {
        print('User not authenticated or widget not mounted.');
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

          if (currentPin.isEmpty || currentPin == savedPin) {
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
