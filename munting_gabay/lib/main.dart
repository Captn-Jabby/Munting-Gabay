import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:munting_gabay/login%20and%20register/login.dart';
import 'package:munting_gabay/login%20and%20register/register_doctor.dart';
import 'package:munting_gabay/login%20and%20register/register_patients.dart';
import 'package:munting_gabay/Patients%20screens/homepage_PT.dart';
import 'package:munting_gabay/variable.dart';

import 'Doctors screen/doctors_homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
      builder: EasyLoading.init(),
      routes: {
        '/homePT': (context) => HomepagePT(),
        '/homeDoctor': (context) => DoctorsHM(),
      },
    );
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: scaffoldBgColor,
        elevation: 0,
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Image.asset(
              'assets/A.png',
              width: 300,
              height: 300,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 200,
                ),
                Container(
                  width: BtnWidth,
                  height: BtnHeight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(BtnCircularRadius))),
                    child: Text(
                      'Login',
                      style: buttonTextStyle,
                    ),
                  ),
                ),
                SizedBox(height: BtnSpacing),
                Container(
                  width: BtnWidth,
                  height: BtnHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(BtnCircularRadius),
                    border: Border.all(color: BtnColor),
                  ),
                  child: TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Register'),
                            content: Text('Register as a Doctor or a Patient?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Close the dialog
                                  // Navigate to the RegistrationPatients with type 'Doctor'
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RegistrationDoctors(),
                                    ),
                                  );
                                },
                                child: Text('Doctor'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Close the dialog
                                  // Navigate to the RegistrationPatients with type 'Patient'
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RegistrationPatients(),
                                    ),
                                  );
                                },
                                child: Text('Patient'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      'Register',
                      style: buttonTextStyle,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
