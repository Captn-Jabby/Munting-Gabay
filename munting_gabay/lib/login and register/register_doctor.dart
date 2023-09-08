import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:munting_gabay/variable.dart';

import 'login.dart';
import '../main.dart';

class RegistrationDoctors extends StatefulWidget {
  @override
  _RegistrationDoctorsState createState() => _RegistrationDoctorsState();
}

class _RegistrationDoctorsState extends State<RegistrationDoctors> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  void _registerUser() async {
    String username = _usernameController.text;
    String name = _nameController.text;
    String address = _addressController.text;
    String age = _ageController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // User registration successful
      print(
          'User registration successful! User ID: ${userCredential.user?.uid}');

      // Save additional user data to Firestore
      await FirebaseFirestore.instance.collection('usersdata').doc(email).set({
        'username': username,
        'name': name,
        'usertype': 'DOCTORS',
        'address': address,
        'age': age,
        'email': email,
      });

      // Perform further actions like saving additional user data to Firestore
    } catch (e) {
      print('Error during user registration: $e');
      // Handle registration errors here
    }

    // Show a success message and navigate to the LoginScreen
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('You are successfully registasdsaered!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Stack(alignment: Alignment.topCenter, children: [
              Image.asset(
                'assets/A.png',
                width: 300,
                height: 300,
              ),
              Container(
                width: 300,
                child: Column(
                  children: [
                    Text('DOCTORS REGISTER PAGE'),
                    SizedBox(
                      height: 270,
                    ),
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), // Adjust the border radius
                          borderSide: BorderSide(
                              color: Colors.blue), // Adjust the border color
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), // Adjust the border radius
                          borderSide: BorderSide(
                              color: Colors.blue), // Adjust the border color
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), // Adjust the border radius
                          borderSide: BorderSide(
                              color: Colors.blue), // Adjust the border color
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextField(
                      controller: _ageController,
                      decoration: InputDecoration(
                        labelText: 'Age',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), // Adjust the border radius
                          borderSide: BorderSide(
                              color: Colors.blue), // Adjust the border color
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), // Adjust the border radius
                          borderSide: BorderSide(
                              color: Colors.blue), // Adjust the border color
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
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
                        onPressed: _registerUser,
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(BtnCircularRadius))),
                        child: Text(
                          'Register',
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
                              content: Text('Are you sure you want to LOGIN?'),
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
                                        builder: (context) => LoginPage(),
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
                        'CLICK HERE TO LOGIN',
                        style: TextStyle(color: Colors.black),
                      ),
                    )
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
