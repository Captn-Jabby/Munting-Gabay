import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'package:munting_gabay/variable.dart';

import 'login.dart';

class RegistrationDOCTORS extends StatefulWidget {
  const RegistrationDOCTORS({super.key});

  @override
  _RegistrationDOCTORSState createState() => _RegistrationDOCTORSState();
}

FirebaseAuth _auth = FirebaseAuth.instance;

class _RegistrationDOCTORSState extends State<RegistrationDOCTORS> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: scaffoldBgColor,
      ),
      backgroundColor: scaffoldBgColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Stack(alignment: Alignment.topCenter, children: [
              Column(
                children: [
                  const Center(
                    child: SpinningContainer(),
                  ),
                  Text(
                    'Munting Gabay',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        letterSpacing: 2,
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                          color: Color(0xFF95C440),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 140),
                    child: Text('An Autism Aid and Awareness App',
                        style: smallTextStyle1),
                  ),
                ],
              ),
              SizedBox(
                width: 300,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 500,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: secondaryColor, // Change this color to the desired background color
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const PersonalIdentificationScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Fill Up Personal Information Form',
                        style: TextStyle(color: text),
                      ),
                    ),
                    const SizedBox(
                      height: 270,
                    ),
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Confirmation'),
                              content: const Text('Are you sure you want to LOGIN?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close the dialog
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close the dialog
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const LoginPage(),
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
  const PersonalIdentificationScreen({super.key});

  @override
  State<PersonalIdentificationScreen> createState() =>
      _PersonalIdentificationScreenState();
}

final _formKey = GlobalKey<FormState>();

class _PersonalIdentificationScreenState
    extends State<PersonalIdentificationScreen> {
  DateTime selectedDate = DateTime.now();
  bool _isPasswordVisible = false;

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
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: const Text('Personal Identification'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  // Text(
                  //   'Personal Identification Form',
                  //   style: TextStyle(color: text, fontSize: 20),
                  // ),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            10.0), // Adjust the border radius
                        borderSide: const BorderSide(
                            color: Colors.blue), // Adjust the border color
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a Username';
                      }
                      return null; // Return null if the validation succeeds
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            10.0), // Adjust the border radius
                        borderSide: const BorderSide(
                            color: Colors.blue), // Adjust the border color
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a Name';
                      }
                      return null; // Return null if the validation succeeds
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            10.0), // Adjust the border radius
                        borderSide: const BorderSide(
                            color: Colors.blue), // Adjust the border color
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a address';
                      }
                      return null; // Return null if the validation succeeds
                    },
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
                        decoration: InputDecoration(
                          labelText: 'Birthdate',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a birthdate';
                          }
                          // Calculate age based on selectedDate
                          DateTime today = DateTime.now();
                          DateTime parsedDate =
                              DateTime.parse(value.split(' ')[0]);
                          int age = today.year - parsedDate.year;
                          if (today.month < parsedDate.month ||
                              (today.month == parsedDate.month &&
                                  today.day < parsedDate.day)) {
                            age--;
                          }
                          // Check if the user is at least 21 years old
                          if (age < 21) {
                            return 'You must be at least 21 years old.';
                          }
                          return null; // Return null if validation succeeds
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: _emailController,
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
                              ? Icons.visibility
                              : Icons.visibility_off,
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
                    height: 15,
                  ),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            10.0), // Adjust the border radius
                        borderSide: const BorderSide(
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
                        return 'Please confirm your Password';
                      } else if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null; // Return null if the validation succeeds
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: secondaryColor, // Change this color to the desired background color
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegistrationDOCTORS(),
                              ),
                            );
                          },
                          child: const Text(
                            'BACK',
                            style: TextStyle(color: text),
                          )),
                      const SizedBox(
                        width: 210,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            // Form is valid, navigate to the next screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DoctorsIdentificationScreen(
                                  userData: UserData(
                                    username: _usernameController.text,
                                    name: _nameController.text,
                                    address: _addressController.text,
                                    birthdate: selectedDate,
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                    confirmPassword:
                                        _confirmPasswordController.text,
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: secondaryColor,
                        ),
                        child: const Text(
                          'Next',
                          style: TextStyle(color: text),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DoctorsIdentificationScreen extends StatefulWidget {
  final UserData userData;

  const DoctorsIdentificationScreen({super.key, required this.userData});

  @override
  State<DoctorsIdentificationScreen> createState() =>
      _DoctorsIdentificationScreenState();
}

// CLINIC INFORMATION

// FirebaseAuth _auth = FirebaseAuth.instance;

class _DoctorsIdentificationScreenState
    extends State<DoctorsIdentificationScreen> {
  bool darkmode = false;
  void _registerUser() async {
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;
    EasyLoading.show(status: 'PlEASE WAIT');

    // Sign out the user (if already authenticated) to clear the session
    if (_auth.currentUser != null) {
      await _auth.signOut();
    }
    final imageUrl = await uploadImageToStorage("IDENTIFICATION");
    final imageUrl2 = await uploadImageToStorage2("LICENSURE");
    final ProfilePicture = await uploadImage("ProfilePicture");
    UserData userData = widget.userData;

    if (password != confirmPassword) {
      // Password and confirm password don't match
      EasyLoading.show(status: 'Password and Confirm Password do not match.');

      return;
    }

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: userData.email,
        password: userData.password,
      );
      await userCredential.user!.sendEmailVerification();
      // User registration successful
      print(
          'User registration successful! User ID: ${userCredential.user?.uid}');

      // Get the currently authenticated user
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        // Access user properties
        String userEmail = currentUser.email ?? '';
        String userUid = currentUser.uid;

        print('User Email: $userEmail');
        print('User UID: $userUid');
      } else {
        // No user is currently authenticated
        print('No user is currently authenticated');
      }

      // Clear controllers and dismiss loading indicator
      _usernameController.clear();
      _nameController.clear();
      _addressController.clear();
      _emailController.clear();
      _passwordController.clear();
      _pinController.clear();
      _confirmPasswordController.clear();
      EasyLoading.dismiss();

      // Save additional user data to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid) // <-- Use UID from UserCredential
          .set({
        'username': userData.username,
        'IDENTIFICATION': imageUrl,
        'Licensure': imageUrl2,
        'name': userData.name,
        'role': 'DOCTORS',
        'address': userData.address,
        'birthdate': userData.birthdate,
        'email': userData.email,
        'status': 'Waiting',
        'avatarPath': ProfilePicture,
        'clinic': _clinicController.text,
        'addressHospital': _addressHospital.text,
        'phone_number': phone_number.text,
        'DoctorStatus': 'Not Available',
        'darkmode': darkmode
      });

      // Perform further actions like saving additional user data to Firestore
    } catch (e, stackTrace) {
      EasyLoading.show(status: 'Error during user registration: $e');
      print('Error during user registration: $e');
      print('Stack trace: $stackTrace');
    }

    EasyLoading.dismiss();
    // Show a success message and navigate to the LoginScreen
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text(
              'You are successfully registered\nPlease check your email for verification!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: const Text('OK'),
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
      appBar: AppBar(
        backgroundColor: scaffoldBgColor,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Doctor\'s Identification Form'),
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: __formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _clinicController,
                        decoration: InputDecoration(
                          labelText: 'Clinic Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a clinic name';
                          }
                          return null; // Return null if the validation succeeds
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: _addressHospital,
                        decoration: InputDecoration(
                          labelText: 'Clinic Address',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a Address';
                          }
                          return null; // Return null if the validation succeeds
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: phone_number,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                        ),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter
                              .digitsOnly, // Allow only digits
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a Phone Number';
                          }
                          return null; // Return null if the validation succeeds
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Divider(
                thickness: 2,
                color: secondaryColor,
              ),
              const Text(
                'Please upload your Identification (ID) and Licensure photos.',
                style: TextStyle(color: text),
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    'Identification',
                    style: TextStyle(
                      color: text,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      // You can also specify other text style properties here, such as fontSize, letterSpacing, etc.
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () {
                          _pickImage(); // Call the function to pick an image from storage
                        },
                        icon: const Icon(
                          Icons.image, // Change to the desired icon
                          color: text, // Change to the desired icon color
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              if (_imageFile != null)
                Image.file(
                  _imageFile!,
                  width: 200,
                  height: 200,
                ),
              Divider(
                thickness: 2,
                color: secondaryColor,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    'Licensure',
                    style: TextStyle(
                      color: text,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      // You can also specify other text style properties here, such as fontSize, letterSpacing, etc.
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () {
                          _pickImage2(); // Call the function to pick an image from storage
                        },
                        icon: const Icon(
                          Icons.badge, // Change to the desired icon
                          color: text, // Change to the desired icon color
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              if (_imageFile2 != null)
                Image.file(
                  _imageFile2!,
                  width: 200,
                  height: 200,
                ),
              Divider(
                thickness: 2,
                color: secondaryColor,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    'Profile Picture',
                    style: TextStyle(
                      color: text,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      // You can also specify other text style properties here, such as fontSize, letterSpacing, etc.
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () {
                          _profilepic(); // Call the function to pick an image from storage
                        },
                        icon: const Icon(
                          Icons.person, // Change to the desired icon
                          color: text, // Change to the desired icon color
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              if (profilepic != null)
                Image.file(
                  profilepic!,
                  width: 200,
                  height: 200,
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryColor, // Change this color to the desired background color
                ),
                onPressed: () {
                  if (__formKey.currentState?.validate() ?? false) {
                    if (_imageFile != null && _imageFile2 != null) {
                      // Both images are selected, you can call the registration process here
                      _registerUser(); // Call the registration process
                      uploadImageToFirebase(
                          _imageFile!,
                          widget
                              .userData.email); // Call the image upload process
                    } else {
                      // Alert dialog when images are not selected
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text(
                                'Please select both images before registering.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                child: const Text(
                                  'OK',
                                  style: TextStyle(color: text),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  }
                },
                child: const Text(
                  'Register',
                  style: TextStyle(color: text),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<String> uploadImageToStorage(String title) async {
    final fileName = '$title-${DateTime.now()}.png';
    final storageRef =
        FirebaseStorage.instance.ref().child('requirments_images/$fileName');
    await storageRef.putFile(_imageFile!);
    return await storageRef.getDownloadURL();
  }

  Future<String> uploadImageToStorage2(String title) async {
    final fileName = '$title-${DateTime.now()}.png';
    final storageRef =
        FirebaseStorage.instance.ref().child('requirments_images/$fileName');
    await storageRef.putFile(_imageFile2!);
    return await storageRef.getDownloadURL();
  }

  Future<String> uploadImage(String title) async {
    final fileName = '$title-${DateTime.now()}.png';
    final storageRef =
        FirebaseStorage.instance.ref().child('requirments_images/$fileName');
    await storageRef.putFile(profilepic!);
    return await storageRef.getDownloadURL();
  }

  /// IMAGEEEEEEEE

  Future<void> uploadImageToFirebase(File imageFile, String email) async {
    try {
      final Reference storageReference = FirebaseStorage.instance.ref().child(
          'user_images/$email/profile_image.jpg'); // Define the storage path

      await storageReference.putFile(imageFile); // Upload the image

      String imageUrl = await storageReference.getDownloadURL();

      // You can save the imageUrl to Firestore or use it as needed

      print('Image uploaded successfully. Image URL: $imageUrl');
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
    }
  }

  final ImagePicker _imagePicker = ImagePicker();
  File? _imageFile;

  Future<void> _pickImage() async {
    final image = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      setState(() {
        _imageFile = null;
      });
    } else {
      setState(() {
        _imageFile = File(image.path);
      });

      if (_imageFile != null) {
        uploadImageToFirebase(_imageFile!, widget.userData.email);
      }
    }
  }

  final ImagePicker profile = ImagePicker();
  File? profilepic;

  Future<void> _profilepic() async {
    final image = await profile.pickImage(source: ImageSource.gallery);

    if (image == null) {
      setState(() {
        profilepic = null;
      });
    } else {
      setState(() {
        profilepic = File(image.path);
      });

      if (profilepic != null) {
        uploadImageToFirebase(profilepic!, widget.userData.email);
      }
    }
  }

  File? _imageFile2;
  final ImagePicker _imagePicker2 = ImagePicker();

  Future<void> _pickImage2() async {
    final image = await _imagePicker2.pickImage(source: ImageSource.gallery);

    if (image == null) {
      setState(() {
        _imageFile2 = null;
      });
    } else {
      setState(() {
        _imageFile2 = File(image.path);
      });

      if (_imageFile2 != null) {
        uploadImageToFirebase(_imageFile2!, widget.userData.email);
      }
    }
  }

  final __formKey = GlobalKey<FormState>();
}

TextEditingController _usernameController = TextEditingController();
TextEditingController _nameController = TextEditingController();
TextEditingController _addressController = TextEditingController();
TextEditingController _emailController = TextEditingController();
TextEditingController _passwordController = TextEditingController();
TextEditingController _pinController = TextEditingController();
TextEditingController _clinicController = TextEditingController();
TextEditingController _addressHospital = TextEditingController();
TextEditingController phone_number = TextEditingController();
TextEditingController _confirmPasswordController =
    TextEditingController(); // New controller for confirm password
