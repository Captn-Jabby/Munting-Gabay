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

        final User? user = result.user;

        if (user != null) {
          // Check if the user's email is verified
          if (user.emailVerified) {
            // Proceed to authenticated area
            EasyLoading.showSuccess('You are successfully logged in.');

            DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();
            String role = userDataSnapshot['role'];

            if (role == 'PATIENTS') {
              Navigator.pushReplacementNamed(context, '/homePT');
            } else if (role == 'DOCTORS') {
              String status = userDataSnapshot['status'];
              if (status == 'Accepted') {
                Navigator.pushReplacementNamed(context, '/homeDoctor');
              } else if (status == 'Rejected') {
                _showError(
                    '''Your doctor account has been rejected.\n\n\nPlease contact 'muntinggabay@gmail.com' for further assistance.''');
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
            // Email not verified, prompt the user to verify their email
            _showError('Email is not verified. Please verify your email.');
            // Optionally, you can prompt the user to resend the verification email
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
      appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFFF4F9EC),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.black,
            ),
          )),
      body: Container(
        padding: const EdgeInsets.all(24),
        decoration: mainBackgroundTheme,
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  Center(
                    child: SpinningContainer(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(21.0),
                    child: Text(
                      'Sign in',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          letterSpacing: 2,
                          textStyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 27,
                              color: Color(0xFF333333))),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
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
                        borderRadius: BorderRadius.circular(50),
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
                  Stack(
                    alignment: Alignment(0.3,-1),
                    children: [
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
                          style: TextStyle(color: text),
                        ),
                      ),
                      Container(
                        height: 34,
                        margin: EdgeInsets.only(top: 30),

                        child: TextButton(
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
                        ),
                      ),
                    ],
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
        padding: EdgeInsets.all(50),
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
