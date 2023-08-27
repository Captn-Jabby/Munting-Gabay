import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:munting_gabay/login%20and%20register/register_patients.dart';
import 'package:munting_gabay/variable.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

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

        if (userType == 'PATIENTS') {
          Navigator.pushReplacementNamed(context, '/homePT');
        } else if (userType == 'DOCTORS') {
          Navigator.pushReplacementNamed(context, '/homeDoctor');
        }
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
                Image.asset(
                  'assets/A.png',
                  width: 300,
                  height: 300,
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
                          borderRadius: BorderRadius.circular(
                              10.0), // Adjust the border radius
                          borderSide: BorderSide(
                              color: Colors.blue), // Adjust the border color
                        ),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: BtnWidth,
                      height: BtnHeight,
                      child: ElevatedButton(
                        onPressed: _signInUser,
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
                      child: Text(
                        'CREATE AN ACCOUNT',
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
