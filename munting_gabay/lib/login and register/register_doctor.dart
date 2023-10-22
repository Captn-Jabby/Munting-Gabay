import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:munting_gabay/login%20and%20register/Doctors_info.dart';
import 'package:munting_gabay/variable.dart';

import 'login.dart';

class RegistrationDOCTORS extends StatefulWidget {
  @override
  _RegistrationDOCTORSState createState() => _RegistrationDOCTORSState();
}

// PERSONAL
TextEditingController _usernameController = TextEditingController();
TextEditingController _nameController = TextEditingController();
TextEditingController _addressController = TextEditingController();
TextEditingController _emailController = TextEditingController();
TextEditingController _passwordController = TextEditingController();
TextEditingController _pinController = TextEditingController();

DateTime selectedDate = DateTime.now();
bool _isPasswordVisible = false;
FirebaseAuth _auth = FirebaseAuth.instance;

class _RegistrationDOCTORSState extends State<RegistrationDOCTORS> {
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
                    SizedBox(
                      height: 500,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PersonalIdentificationScreen(),
                          ),
                        );
                      },
                      child: Text('Fill Up Personal Information Form'),
                    ),
                    SizedBox(
                      height: 270,
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

class PersonalIdentificationScreen extends StatefulWidget {
  @override
  State<PersonalIdentificationScreen> createState() =>
      _PersonalIdentificationScreenState();
}

class _PersonalIdentificationScreenState
    extends State<PersonalIdentificationScreen> {
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
        title: Text('Personal Identification'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Personal Identification Form'),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(10.0), // Adjust the border radius
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
                    borderRadius:
                        BorderRadius.circular(10.0), // Adjust the border radius
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
                    borderRadius:
                        BorderRadius.circular(10.0), // Adjust the border radius
                    borderSide: BorderSide(
                        color: Colors.blue), // Adjust the border color
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextField(
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
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(10.0), // Adjust the border radius
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
                    borderRadius:
                        BorderRadius.circular(10.0), // Adjust the border radius
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
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegistrationDOCTORS(),
                          ),
                        );
                      },
                      child: Text('BACK')),
                  Container(
                    width: BtnWidth,
                    height: BtnHeight,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DoctorsIdentificationScreen(
                              userData: UserData(
                                username: _usernameController.text,
                                name: _nameController.text,
                                address: _addressController.text,
                                birthdate: selectedDate,
                                email: _emailController.text,
                                password: _passwordController.text,
                              ),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xBA205007),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(BtnCircularRadius))),
                      child: Text(
                        'Next',
                        style: buttonTextStyle,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
