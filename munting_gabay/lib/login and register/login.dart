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
  bool _isPasswordValid = true;

  bool _validatePassword(String password) {
    return password.length >= 6;
  }

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
              child: const Text('Okay'),
            ),
          ],
        );
      },
    );
  }

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

  void _signInUser(BuildContext context) {
    EasyLoading.show(status: 'Logging in...');

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    setState(() {
      _isPasswordValid = _validatePassword(password);
    });

    if (_isPasswordValid) {
      _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((auth) async {
        final User user = auth.user!;

        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get()
            .then(
          (loggedInUser) async {
            if (!loggedInUser.exists) {
              _showError(
                  "Cannot fetch your data. Please ensure that this account is registered and try again");

              await FirebaseAuth.instance.signOut();
              return;
            }

            if (loggedInUser.get("role") != "PATIENTS") {
              _showError(
                  "Cannot authorize your login attempt with this account. Please try again with an account with appropriate role to continue.");

              await FirebaseAuth.instance.signOut();

              return;
            }

            if (!user.emailVerified) {
              _showResendEmailDialog(context);

              await FirebaseAuth.instance.signOut();
              return;
            }

            Navigator.popUntil(context, (route) => route.isFirst);
          },
        ).catchError((error) {
          _showError("Cannot fetch data for validation. Please try again.");
        });
      }).catchError(
        (error) {
          _showError(
              'There is no user record corresponding to this email address.\nPlease check your email or try registering.');
        },
      ).whenComplete(
        () => EasyLoading.dismiss(),
      );
    } else {
      _showError('Invalid password.');
      EasyLoading.dismiss();
    }
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
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: mainBackgroundTheme,
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
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
                      fontWeight: FontWeight.bold,
                      fontSize: 27,
                      color: const Color(0xFF333333),
                    ),
                  ),
                ),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
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
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                  ),
                  obscureText: !_isPasswordVisible,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => _signInUser(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF95C440),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
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
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RegistrationPatients(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Confirm',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text(
                    'CREATE AN ACCOUNT',
                    style: TextStyle(color: Color(0xFF333333)),
                  ),
                ),
                TextButton(
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
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgotPasswordScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Confirm',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text(
                    'Forgot Password',
                    style: TextStyle(color: Color(0xFF333333)),
                  ),
                ),
              ],
            ),
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
      duration: const Duration(minutes: 1),
    )..repeat();
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
            image: AssetImage("assets/images/world.png"),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
