import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:munting_gabay/variable.dart';

import '../main.dart';

class RegistrationPatients extends StatefulWidget {
  const RegistrationPatients({super.key});

  @override
  _RegistrationPatientsState createState() => _RegistrationPatientsState();
}

class _RegistrationPatientsState extends State<RegistrationPatients> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _pinController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  bool _isPasswordVisible = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool pinStatus = true;
  final _formKey = GlobalKey<FormState>();

  void _registerUser() async {
    EasyLoading.show(status: 'Please wait');
    String username = _usernameController.text;
    String name = _nameController.text;
    String address = _addressController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPassword =
        _confirmPasswordController.text; // New variable for confirm password
    String pin = _pinController.text;

    if (password != confirmPassword) {
      // Password and confirm password don't match
      EasyLoading.showError('Password and Confirm Password do not match.');
      EasyLoading.dismiss();
      return;
    }

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user!.sendEmailVerification();
      // User registration successful
      print(
          'User registration successful! User ID: ${userCredential.user?.uid}');

      // Save additional user data to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'username': username,
        'name': name,
        'role': 'PATIENTS',
        'address': address,
        'birthdate': selectedDate,
        'email': email,
        'pinStatus': pinStatus,
        'pin': pin.isEmpty ? '1234' : pin, // Set pin to '1234' if empty
        'avatarPath':
            'https://firebasestorage.googleapis.com/v0/b/munting-gabay-4f845.appspot.com/o/avatars%2Fbened8ct12%40gmail.com.jpg?alt=media&token=70d751a6-b53e-4c6c-a146-a916efc1fe93'
      });

      // Perform further actions like saving additional user data to Firestore
      EasyLoading.dismiss();

      // Show a success message and navigate to the LoginScreen
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text(
                'You are successfully registered! Please check email inbox for verification'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e, stackTrace) {
      EasyLoading.showError('Error during user registration: $e');
      print('Error during user registration: $e');
      print('Stack trace: $stackTrace');

      // Handle registration errors here
      EasyLoading.dismiss();
    }
  }

  // Selection of date
  Future<void> _selectDate(BuildContext context) async {
    // remove focus first
    if (FocusScope.of(context).focusedChild != null) {
      FocusScope.of(context).focusedChild!.unfocus();
    }

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

    if (picked != selectedDate) {
      setState(() {
        selectedDate = picked!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
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
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: mainBackgroundTheme,
          // width: double.infinity,
          // height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Text(
                    'Register',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      letterSpacing: 1,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        color: Color(0xFF95C440),
                      ),
                    ),
                  ),
                  const SizedBox(height: 21),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _usernameController,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Adjust the border radius
                              borderSide: const BorderSide(
                                  color:
                                      Colors.blue), // Adjust the border color
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a Username ';
                            }
                            return null; // Return null if the validation succeeds
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: _nameController,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Adjust the border radius
                              borderSide: const BorderSide(
                                  color:
                                      Colors.blue), // Adjust the border color
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a  name';
                            }
                            return null; // Return null if the validation succeeds
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: _addressController,
                          keyboardType: TextInputType.streetAddress,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Address',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Adjust the border radius
                              borderSide: const BorderSide(
                                  color:
                                      Colors.blue), // Adjust the border color
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the address';
                            }
                            return null; // Return null if the validation succeeds
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                          ],
                          controller: _pinController,
                          maxLength: 4,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          onChanged: (value) {
                            setState(() {
                              pinStatus =
                                  (value.isNotEmpty && value.length == 4);
                            });
                          },
                          decoration: InputDecoration(
                            labelText:
                                'Pincode for Parent\'s Pages (OPTIONAL) ',
                            hintText: 'Pin is set to default: 1234',
                            counterText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(color: Colors.blue),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        GestureDetector(
                          onTap: () => _selectDate(context),
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: TextEditingController(
                                text: "${selectedDate.toLocal()}".split(' ')[0],
                              ),
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: 'Birthdate',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide:
                                      const BorderSide(color: Colors.blue),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a birthdate';
                                }
                                DateTime today = DateTime.now();
                                DateTime parsedDate =
                                    DateTime.parse(value.split(' ')[0]);
                                int age = today.year - parsedDate.year;
                                if (today.month < parsedDate.month ||
                                    (today.month == parsedDate.month &&
                                        today.day < parsedDate.day)) {
                                  age--;
                                }
                                if (age < 18) {
                                  return 'You must be at least 18 years old.';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(color: Colors.blue),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email';
                            } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@gmail.com$')
                                .hasMatch(value)) {
                              return 'Please enter a valid Gmail address';
                            }
                            return null; // Return null if the validation succeeds
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: _passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(color: Colors.blue),
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a Password';
                            } else if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null; // Return null if the validation succeeds
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          controller: _confirmPasswordController,
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Adjust the border radius
                              borderSide: const BorderSide(
                                  color:
                                      Colors.blue), // Adjust the border color
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your Password';
                            } else if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null; // Return null if the validation succeeds
                          },
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: BtnWidth,
                          height: BtnHeight,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _registerUser();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: secondaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  BtnCircularRadius,
                                ),
                              ),
                            ),
                            child: Text(
                              'Register',
                              style: buttonTextStyle1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SpinningContainerP extends StatefulWidget {
  const SpinningContainerP({super.key});

  @override
  _SpinningContainerPState createState() => _SpinningContainerPState();
}

class _SpinningContainerPState extends State<SpinningContainerP>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
          minutes: 1), // Set the duration for one complete rotation
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
