import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:munting_gabay/Doctors%20screen/dr_dashboard.dart';
import 'package:munting_gabay/login%20and%20register/login.dart';
import 'package:munting_gabay/login%20and%20register/register_doctor.dart';
import 'package:munting_gabay/login%20and%20register/register_patients.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/homepage_PT.dart';
import 'package:munting_gabay/variable.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'Adminpage/adminpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox<String>('avatarBox');
  runApp(
    MyApp(),
  );
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.circle
    ..userInteractions = false
    ..loadingStyle = EasyLoadingStyle.dark
    ..maskType = EasyLoadingMaskType.black
    ..dismissOnTap = false;
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       // home: LoginScreen(),
//       home: StreamBuilder(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             return HomepagePT();
//           } else {
//             return LoginScreen();
//           }
//         },
//       ),
//       builder: EasyLoading.init(),
//       routes: {
//         '/homePT': (context) => HomepagePT(),
//         '/homeDoctor': (context) => DocDashboard(),
//         '/homeAdmin': (context) => AdminPage(),
//       },
//     );
//   }
// }
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                // Color of the loading indicator
                valueColor: AlwaysStoppedAnimation<Color>(LoadingColor),

                // Width of the indicator's line
                strokeWidth: 4,

                // Optional: Background color of the circle
                backgroundColor: bgloadingColor,
              ),
            );
          }

          if (snapshot.hasData) {
            User? user = snapshot.data;
            if (user != null) {
              return FutureBuilder<DocumentSnapshot>(
                future: getUserDataFromFirestore(user),
                builder: (context, userDataSnapshot) {
                  if (userDataSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        // Color of the loading indicator
                        valueColor: AlwaysStoppedAnimation<Color>(LoadingColor),

                        // Width of the indicator's line
                        strokeWidth: 4,

                        // Optional: Background color of the circle
                        backgroundColor: bgloadingColor,
                      ),
                    );
                  }

                  String userType =
                      userDataSnapshot.data?.get('usertype') ?? '';

                  if (userType == 'PATIENTS') {
                    return HomepagePT();
                  } else if (userType == 'DOCTORS') {
                    String status = userDataSnapshot.data?.get('status') ?? '';

                    if (status == 'Accepted') {
                      return DocDashboard(docId: user.email!);
                    } else if (status == 'ADMIN') {
                      return AdminPage();
                    } else {
                      return Text("EMPTY");
                    }
                  } else {
                    return InvalidUserTypeScreen();
                  }
                },
              );
            }
          }

          return LoginScreen();
        },
      ),
      builder: EasyLoading.init(),
      routes: {
        '/homePT': (context) => HomepagePT(),
        '/homeDoctor': (context) {
          // Access user.email and pass it as docId
          User? user = FirebaseAuth.instance.currentUser;
          return DocDashboard(
              docId: user?.email ??
                  ''); // You can pass an empty string or handle null values
        },
        '/homeAdmin': (context) => AdminPage(),
      },
    );
  }

  Future<DocumentSnapshot> getUserDataFromFirestore(User user) async {
    return await FirebaseFirestore.instance
        .collection('usersdata')
        .doc(user.email)
        .get();
  }
}

class InvalidUserTypeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invalid User Type'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Invalid User Type',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'You do not have a valid user type for this app.',
              style: TextStyle(fontSize: 16),
            ),
            // You can add more widgets, buttons, or information as needed
          ],
        ),
      ),
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
      body: Container(
        child: Center(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              // Image.asset(
              //   'assets/A.png',
              //   width: 300,
              //   height: 300,
              // ),
              Column(
                children: [
                  Text('Munting\nGabay',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 5,
                        shadows: [
                          Shadow(
                              color: Color(0xBA205007).withOpacity(1.0),
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

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
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
                          backgroundColor: Color(0xBA205007),
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
                      color: const Color(0xFF8FCC62),
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
                              content:
                                  Text('Register as a Doctor or a Patient?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close the dialog
                                    // Navigate to the RegistrationPatients with type 'Doctor'
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            RegistrationDOCTORS(),
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
      ),
    );
  }
}
