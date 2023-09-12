// login
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:munting_gabay/login%20and%20register/register_patients.dart';
import 'package:munting_gabay/variable.dart';

import 'forgetpassword.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  Future<void> _signInUser() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      EasyLoading.showSuccess('You are successfully logged in.');

      User? user = userCredential.user;

      if (user != null) {
        DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance
            .collection('usersdata')
            .doc(user.email)
            .get();
        String userType = userDataSnapshot['usertype'];


        if(userType == 'PATIENTS'){
          print('User is a PATIENTS');
          Navigator.pushReplacementNamed(context, '/homePT');
        } else if (userType == 'DOCTORS') {
          String status = userDataSnapshot['status'];
          if (status == 'Accepted') {
            Navigator.pushReplacementNamed(context, '/homeDoctor');
          } else if (status == 'ADMIN') {
            Navigator.pushReplacementNamed(context, '/homeAdmin');
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Account Not Accepted'),
                  content: Text(
                      'Your doctor account has not been accepted yet. Please wait for approval.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the dialog
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        }
        // else if (userType == 'ADMIN') {
        //   // Check if the user ID is the specific admin user ID
        //   // if (userCredential.user?.uid == 'e4gsq87sW5gIxLgabhzC6by50oR2') {
        //   // Redirect to the admin page
        //   Navigator.pushReplacementNamed(context, '/homeAdmin');
        //   // }
        //   // else {
        //   //   // For other admin users, redirect to the '/homeDoctor' page
        //   //   Navigator.pushReplacementNamed(context, '/homeDoctor');
        //   // }
        // }
      }

      EasyLoading.dismiss();
    } on FirebaseAuthException catch (ex) {
      EasyLoading.showError('Login failed: ${ex.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 23,
                    ),
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
                SizedBox(
                  height: BtnSpacing,
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 300,
                    ),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), // Adjust the border radius
                          borderSide: BorderSide(
                              color: Colors.black), // Adjust the border color
                        ),
                      ),
                    ),
                    SizedBox(
                      height: BtnSpacing,
                    ),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color:
                                Colors.blue, // You can adjust the border color
                          ),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          child: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      obscureText: !_isPasswordVisible,
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: BtnWidth,
                      height: BtnHeight,
                      child: ElevatedButton(
                        onPressed: _signInUser,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xBA205007),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(BtnCircularRadius))),
                        child: Text(
                          'Login',
                          style: buttonTextStyle,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Confirmation'),
                              content: Text(
                                  'Are you sure you want to create an account?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close the dialog
                                  },
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close the dialog
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            RegistrationPatients(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Confirm',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text(
                        'CREATE AN ACCOUNT',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Confirmation'),
                              content: Text(
                                  'Are you sure you want to Forgot Password?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close the dialog
                                  },
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close the dialog
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ForgotPasswordScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Confirm',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text(
                        'Forgot Password',
                        style: TextStyle(color: Colors.black),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
