import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:munting_gabay/login%20and%20register/register_patients.dart';
import 'package:munting_gabay/variable.dart';

import 'forgetpassword.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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
          backgroundColor: const Color(0xFF95C440),
          title: Text(title),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Okay')),
          ],
        );
      },
    );
  }

//////////////////////////////
  void _resendVerificationEmail() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.sendEmailVerification();
        _showError('Verification email sent. Please check your email.');
      } else {
        _showError('User not found. Please log in again.');
      }
    } catch (error) {
      _showError('Error sending verification email: $error');
    }
  }

  void _showResendEmailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Email Verification'),
          content: const Text(
              'Your email is not verified. Would you like to resend the verification email?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resendVerificationEmail();
              },
              child: const Text('Resend Email'),
            ),
          ],
        );
      },
    );
  }

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
                _showError('''Your doctor account has been rejected.
              \n\nPlease contact 'muntinggabay@gmail.com' for further assistance.''');
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
            _showResendEmailDialog(context);
          }
        } else {
          // User does not exist
          _showError('User does not exist. Please sign up first.');
        }
      } catch (error) {
        _showError(
            'There is no user record corresponding to this email address.\nPlease check your email or try registering.');
      }
    } else {
      _showError(
          'Information Empty');//invalid password logic history
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
                  const Center(
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
                              color: const Color(0xFF333333))),
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
                  const SizedBox(
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
                  const SizedBox(height: 20),
                  SizedBox(
                    width: BtnWidth,
                    height: BtnHeight,
                    child: ElevatedButton(
                      onPressed: () => _signInUser(context),
                      style: buttonStyle1,
                      child: Text(
                        'Login',
                        style: buttonTextStyle1,
                      ),
                    ),
                  ),
                  Stack(
                    alignment: const Alignment(0.3, -1),
                    children: [
                      TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Confirmation'),
                                content: const Text(
                                    'Are you sure you want to create an account?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(
                                          context); // Close the dialog
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(
                                          context); // Close the dialog
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const RegistrationPatients(),
                                        ),
                                      );
                                    },
                                    child: const Text(
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
                        margin: const EdgeInsets.only(top: 30),
                        child: TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Confirmation'),
                                  content: const Text(
                                      'Are you sure you want to Forgot Password?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(
                                            context); // Close the dialog
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(
                                            context); // Close the dialog
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const ForgotPasswordScreen(),
                                          ),
                                        );
                                      },
                                      child: const Text(
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
  const SpinningContainer({super.key});

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
          const Duration(minutes: 1), // Set the duration for one complete rotation
    )..repeat(); // Repeat the animation infinitely
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Container(
        padding: const EdgeInsets.all(50),
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
