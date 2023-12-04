import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:munting_gabay/variable.dart';

import 'login.dart';
import '../main.dart';

class RegistrationPatients extends StatefulWidget {
  @override
  _RegistrationPatientsState createState() => _RegistrationPatientsState();
}

class _RegistrationPatientsState extends State<RegistrationPatients> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _pinController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  bool _isPasswordVisible = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool pinStatus = false;

  void _registerUser() async {
    String username = _usernameController.text;
    String name = _nameController.text;
    String address = _addressController.text;
    // String age = _ageController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String pin = _pinController.text;

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
        'usertype': 'PATIENTS',
        'address': address,
        'birthdate': selectedDate,
        'email': email,
        'pinStatus': pinStatus,
        'pin': pin,
        'avatarPath':
            'https://firebasestorage.googleapis.com/v0/b/munting-gabay-4f845.appspot.com/o/avatars%2Fbened8ct12%40gmail.com.jpg?alt=media&token=70d751a6-b53e-4c6c-a146-a916efc1fe93'
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
          content: Text('You are successfully registered!'),
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

  // Selection of date
  Future<void> _selectDate(BuildContext context) async {
    DateTime currentDate = DateTime.now();
    DateTime firstDate = DateTime(1900);
    DateTime lastDate = DateTime(2101);

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: firstDate,
      lastDate: lastDate,
      selectableDayPredicate: (DateTime day) {
        // Allow only dates without time
        return day.isBefore(currentDate) || day.isAtSameMomentAs(currentDate);
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
      ),
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
                    SizedBox(
                      height: 270,
                    ),
                    TextFormField(
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a Username ';
                        }
                        return null; // Return null if the validation succeeds
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a  name';
                        }
                        return null; // Return null if the validation succeeds
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the address';
                        }
                        return null; // Return null if the validation succeeds
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextField(
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                      ],
                      controller: _pinController,
                      maxLength: 4, // Set the maximum length to 4 digits
                      keyboardType:
                          TextInputType.number, // Set keyboard type to number
                      onChanged: (value) {
                        // Check if the pin field is empty and update pinStatus accordingly
                        setState(() {
                          pinStatus = (value.isNotEmpty && value.length == 4);
                        });
                      },
                      decoration: InputDecoration(
                        labelText:
                            '''Pincode for Parent's Pages   (OPTIONAL)''',
                        counterText: '', // Hide the character counter
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: TextEditingController(
                              text: "${selectedDate.toLocal()}".split(
                                  ' ')[0]), // Format to show only the date part
                          decoration: InputDecoration(
                            labelText: 'Birthdate',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a Email';
                        }
                        return null; // Return null if the validation succeeds
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), // Adjust the border radius
                          borderSide: BorderSide(
                              color: Colors.blue), // Adjust the border color
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a Password';
                        }
                        return null; // Return null if the validation succeeds
                      },
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: BtnWidth,
                      height: BtnHeight,
                      child: ElevatedButton(
                        onPressed: _registerUser,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: scaffoldBgColor,
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
                        style: TextStyle(color: Colors.white),
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
