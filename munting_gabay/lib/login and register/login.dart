import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:munting_gabay/login%20and%20register/register_patients.dart';
import 'package:munting_gabay/variable.dart';

import 'forgetpassword.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _ispasswordValid = true;

  /////////////////////////
  bool _validatePassword(String password) {
    return password.length >= 6;
  }

  ////////////////////
  void _showError(String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(title),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Okay')),
          ],
        );
      },
    );
  }

//////////////////////////////
  void _signInUser(BuildContext context) async {
    EasyLoading.show(status: 'Logging in...');

    await Future.delayed(Duration(seconds: 2));
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    setState(() {
      _ispasswordValid = _validatePassword(password);
    });
    if (_ispasswordValid) {
      try {
        UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        EasyLoading.showSuccess('You are successfully logged in.');

        final User? user = result.user;

        if (user != null) {
          DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance
              .collection('usersdata')
              .doc(user.email)
              .get();
          String userType = userDataSnapshot['usertype'];

          if (userType == 'PATIENTS') {
            Navigator.pushReplacementNamed(context, '/homePT');
          } else if (userType == 'DOCTORS') {
            String status = userDataSnapshot['status'];
            if (status == 'Accepted') {
              Navigator.pushReplacementNamed(context, '/homeDoctor');
            } else if (status == 'ADMIN') {
              Navigator.pushReplacementNamed(context, '/homeAdmin');
            } else {
              _showError(
                  'Your doctor account has not been accepted yet. Please wait for approval.');
            }
          } else {
            _showError('Invalid user type');
          }
        } else {
          _showError('Login failed');
        }
      } catch (error) {
        _showError('Login error: $error');
      }
    }
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: mainBackgroundTheme,
        child: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 24),
                    height: MediaQuery.of(context).size.height / 4,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/world.png",)
                        )
                    ),
                  ),
                  Text('Munting Gabay',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        letterSpacing: 2,
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                          color: Color(0xFF95C440),
                        )
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 140),
                    child: Text('An Autism Aid and Awareness App',
                        style: smallTextStyle1
                    ),
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
                  Container(
                    child: Column(
                      children: [
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Adjust the border radius
                              borderSide: BorderSide(
                                  color: Colors
                                      .black), // Adjust the border color
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
                                color: Colors
                                    .blue, // You can adjust the border color
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
                            onPressed: () => _signInUser(context),
                            child: Text(
                              'Login',
                              style: buttonTextStyle1,
                            ),
                            style: buttonStyle1,
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
                                        Navigator.pop(
                                            context); // Close the dialog
                                      },
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(
                                            context); // Close the dialog
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
                      ],
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
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
