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
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'Adminpage/adminpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Hive.registerAdapter<Color>(ColorAdapter()); // Register the ColorAdapter
  await Hive.initFlutter();
  await Hive.openBox<Color>('colors'); // Open a box to store colors
  runApp(MyApp());
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.circle
    ..userInteractions = false
    ..loadingStyle = EasyLoadingStyle.dark
    ..maskType = EasyLoadingMaskType.black
    ..dismissOnTap = false;
}

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
            return const Center(
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
                    return const Center(
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

                  String role = userDataSnapshot.data?.get('role') ?? '';

                  if (role == 'PATIENTS') {
                    return const HomepagePT();
                  } else if (role == 'DOCTORS') {
                    String status = userDataSnapshot.data?.get('status') ?? '';

                    if (status == 'Accepted') {
                      return DocDashboard(docId: user.email!);
                    } else if (status == 'ADMIN') {
                      return const AdminPage();
                    } else {
                      return LoginScreen();
                    }
                  } else {
                    return InvalidroleScreen();
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
        '/homePT': (context) => const HomepagePT(),
        '/homeDoctor': (context) {
          // Access user.email and pass it as docId
          User? user = FirebaseAuth.instance.currentUser;
          return DocDashboard(
              docId: user?.email ??
                  ''); // You can pass an empty string or handle null values
        },
        '/homeAdmin': (context) => const AdminPage(),
      },
    );
  }

  Future<DocumentSnapshot> getUserDataFromFirestore(User user) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(user.email)
        .get();
  }
}

class InvalidroleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invalid User Type'),
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
            ElevatedButton(
              onPressed: () {
                // Navigate to the LoginScreen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text('Log in'),
            ),
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
      body: Container(
        decoration: mainBackgroundTheme,
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Container(
          padding: const EdgeInsets.only(top: 75),
          child: Column(
            children: [
              Center(
                child: SpinningContainer(),
              ),

              Text(
                'Munting Gabay',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    letterSpacing: 2,
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      color: Color(0xFF95C440),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 140),
                child: Text('An Autism Aid and Awareness App',
                    style: smallTextStyle1),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 4,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: BtnHeight,
                      width: BtnWidth,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF95C440),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50))),
                        child: Text(
                          'Get Started',
                          style: buttonTextStyle1,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 21,
                    ),
                    SizedBox(
                      width: BtnWidth,
                      height: BtnHeight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFDFDFE),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50))),
                        child: Text("Login", style: buttonTextStyle2),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'New around here?',
                          style: smallTextStyle2,
                        ),
                        TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Register'),
                                    content: const Text(
                                        'Register as a Doctor or a Patient?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(
                                              context); // Close the dialog
                                          // Navigate to the RegistrationPatients with type 'Doctor'
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  RegistrationDOCTORS(),
                                            ),
                                          );
                                        },
                                        child: const Text('Doctor'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(
                                              context); // Close the dialog
                                          // Navigate to the RegistrationPatients with type 'Patient'
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  RegistrationPatients(),
                                            ),
                                          );
                                        },
                                        child: const Text('Patient'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text(
                              'Sign up',
                              style: smallTextStyle3,
                            )),
                      ],
                    )
                  ],
                ),
              ),

              // Container(
              //   width: BtnWidth,
              //   height: BtnHeight,
              //   decoration: BoxDecoration(
              //     // color: const Color(0xFF18B091),
              //     color: const Color(0xFF95C440),
              //     borderRadius: BorderRadius.circular(BtnCircularRadius),
              //   ),
              //   child: TextButton(
              //     onPressed: () {
              //       showDialog(
              //         context: context,
              //         builder: (BuildContext context) {
              //           return AlertDialog(
              //             title: const Text('Register'),
              //             content:
              //                 const Text('Register as a Doctor or a Patient?'),
              //             actions: [
              //               TextButton(
              //                 onPressed: () {
              //                   Navigator.pop(context); // Close the dialog
              //                   // Navigate to the RegistrationPatients with type 'Doctor'
              //                   Navigator.push(
              //                     context,
              //                     MaterialPageRoute(
              //                       builder: (context) =>
              //                           RegistrationDOCTORS(),
              //                     ),
              //                   );
              //                 },
              //                 child: const Text('Doctor'),
              //               ),
              //               TextButton(
              //                 onPressed: () {
              //                   Navigator.pop(context); // Close the dialog
              //                   // Navigate to the RegistrationPatients with type 'Patient'
              //                   Navigator.push(
              //                     context,
              //                     MaterialPageRoute(
              //                       builder: (context) =>
              //                           RegistrationPatients(),
              //                     ),
              //                   );
              //                 },
              //                 child: const Text('Patient'),
              //               ),
              //             ],
              //           );
              //         },
              //       );
              //     },
              //     child: Text(
              //       'Register',
              //       style: buttonTextStyle1,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class SpinningContainer extends StatefulWidget {
  @override
  _SpinningContainerState createState() => _SpinningContainerState();
}

class _SpinningContainerState extends State<SpinningContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration:
          Duration(minutes: 1), // Set the duration for one complete rotation
    )..repeat(); // Repeat the animation infinitely
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Container(
        height: MediaQuery.of(context).size.height / 4,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
          "assets/images/world.png",
        ))),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
