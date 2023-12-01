import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/screens/kids%20page/Kids_page.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/screens/parents%20page/Parent_page.dart';
import 'package:munting_gabay/drawer_page.dart';
import 'package:munting_gabay/login%20and%20register/pincode.dart';
import 'package:munting_gabay/variable.dart';

class HomepagePT extends StatefulWidget {
  const HomepagePT({Key? key});

  @override
  State<HomepagePT> createState() => _HomepagePTState();
}

class _HomepagePTState extends State<HomepagePT> {
  bool pinEnabled = false; // Initially set to false

  @override
  void initState() {
    super.initState();
    getPinEnabledFromFirebase();
  }

  void getPinEnabledFromFirebase() async {
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
          setState(() {
            pinEnabled = userDataMap['pinStatus'] ?? false;
          });
        } else {
          print('User data not found in Firestore.');
        }
      } else {
        print('User not authenticated.');
      }
    } catch (e) {
      print('Error retrieving PIN status: $e');
    }
  }

  Future<void> _onButtonPressed() async {
    EasyLoading.show(status: 'Please wait');
    await Future.delayed(Duration(seconds: 2));
    if (pinEnabled) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ParentPage()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PinScreen()),
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
        iconTheme: const IconThemeData(color: BtnColor),
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
                  Text('Munting\nGabay',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 5,
                        shadows: [
                          Shadow(
                              color: const Color(0xBA205007).withOpacity(1.0),
                              offset: const Offset(7, 2))
                        ],
                        fontSize: 75,
                        color: Colors.white,
                      )),
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                    'A MOBILE-BASED AUTISM AID\nAND AWARENESS APPLICATION',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/hands.png',
                    width: LOGOSIZE,
                    height: LOGOSIZE,
                  ),
                  SizedBox(
                    width: lOGOSpacing,
                  ),
                  SizedBox(
                    width: BtnWidth,
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
                      child: const Text(
                        'Parents',
                        style: buttonTextStyle,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: BtnSpacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/playtime.png',
                    width: LOGOSIZE,
                    height: LOGOSIZE,
                  ),
                  SizedBox(
                    width: lOGOSpacing,
                  ),
                  Container(
                    width: BtnWidth,
                    height: BtnHeight,
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(BtnCircularRadius),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => KidsPage()),
                        );
                      },
                      child: const Text(
                        'Child',
                        style: buttonTextStyle,
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
