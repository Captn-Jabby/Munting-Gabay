import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/screens/kids%20page/Kids_page.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/screens/parents%20page/Parent_page.dart';
import 'package:munting_gabay/drawer_page.dart';
import 'package:munting_gabay/login%20and%20register/login.dart';
import 'package:munting_gabay/login%20and%20register/pincode.dart';
import 'package:munting_gabay/variable.dart';

class HomepagePT extends StatefulWidget {
  const HomepagePT({super.key, Key});

  @override
  State<HomepagePT> createState() => _HomepagePTState();
}

class _HomepagePTState extends State<HomepagePT> {
  bool pinEnabled = false; // Initially set to false
  late StreamSubscription<DocumentSnapshot> _pinStatusSubscription;
  @override
  void initState() {
    super.initState();
    // Call the method to set up the real-time listener
    setupPinStatusListener();
  }

  void setupPinStatusListener() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final CollectionReference usersDataCollection =
            FirebaseFirestore.instance.collection('users');

        final String? currentUserEmail = user.email;

        // Set up a real-time listener for changes to the document
        _pinStatusSubscription =
            usersDataCollection.doc(currentUserEmail).snapshots().listen(
          (DocumentSnapshot userData) {
            if (userData.exists) {
              final Map<String, dynamic> userDataMap =
                  userData.data() as Map<String, dynamic>;
              setState(() {
                pinEnabled = userDataMap['pinStatus'] ?? false;
              });
            } else {
              print('User data not found in Firestore.');
            }
          },
        );
      } else {
        print('User not authenticated.');
      }
    } catch (e) {
      print('Error setting up PIN status listener: $e');
    }
  }

  @override
  void dispose() {
    // Cancel the subscription to avoid setState after dispose
    _pinStatusSubscription.cancel();
    super.dispose();
  }

  Future<void> _onButtonPressed() async {
    EasyLoading.show(status: 'Please wait');
    await Future.delayed(const Duration(seconds: 2));
    if (pinEnabled) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ParentPage()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PinScreen()),
      );
    }
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: scaffoldBgColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: text),
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [

              Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  const Center(
                    child: SpinningContainer(),
                  ),
                  Text(
                    'Munting Gabay',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        letterSpacing: 2,
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                          color: secondaryColor,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: Text('An Autism Aid and Awareness App',
                        style: smallTextStyle1),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/hands.png',
                    width: LOGOSIZE,
                    height: LOGOSIZE,
                  ),
                  const SizedBox(
                    width: lOGOSpacing,
                  ),
                  SizedBox(
                    width: BtnWidth - minus,
                    height: BtnHeight,
                    child: ElevatedButton(
                      onPressed: () {
                        _onButtonPressed();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: secondaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(BtnCircularRadius),
                        ),
                      ),
                      child: Text(
                        'Parents',
                        style: buttonTextStyle1,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: BtnSpacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/playtime.png',
                    width: LOGOSIZE,
                    height: LOGOSIZE,
                  ),
                  const SizedBox(
                    width: lOGOSpacing,
                  ),
                  Container(
                    width: BtnWidth - minus,
                    height: BtnHeight,
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(BtnCircularRadius),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const KidsPage()),
                        );
                      },
                      child: Text(
                        'Child',
                        style: buttonTextStyle1,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
