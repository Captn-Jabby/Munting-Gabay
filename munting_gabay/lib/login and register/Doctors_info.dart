import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:munting_gabay/login%20and%20register/login.dart';
import 'package:munting_gabay/variable.dart';

class DoctorsIdentificationScreen extends StatefulWidget {
  final UserData userData;

  DoctorsIdentificationScreen({required this.userData});

  @override
  State<DoctorsIdentificationScreen> createState() =>
      _DoctorsIdentificationScreenState();
}

// CLINIC INFORMATION
TextEditingController _clinicController = TextEditingController();
TextEditingController _addressHospital = TextEditingController();
FirebaseAuth _auth = FirebaseAuth.instance;

class _DoctorsIdentificationScreenState
    extends State<DoctorsIdentificationScreen> {
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

  void _registerUser() async {
    _clinicController.clear();
    _addressHospital.clear();

    // Sign out the user (if already authenticated) to clear the session
    if (_auth.currentUser != null) {
      await _auth.signOut();
    }
    final imageUrl = await uploadImageToStorage("IDENTIFICATION");
    final imageUrl2 = await uploadImageToStorage2("LICENSURE");
    UserData userData = widget.userData;
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: userData.email,
        password: userData.password,
      );

      // User registration successful
      print(
          'User registration successful! User ID: ${userCredential.user?.uid}');

      // Save additional user data to Firestore
      await FirebaseFirestore.instance
          .collection('usersdata')
          .doc(userData.email)
          .set({
        'username': userData.username,
        'IDENTIFICATION': imageUrl,
        'Licensure': imageUrl2,
        'name': userData.name,
        'usertype': 'DOCTORS',
        'address': userData.address,
        'birthdate': userData.birthdate,
        'email': userData.email,
        'status': 'Waiting',
        'avatarPath': 'assets/avatar1.png',
        'clinic': _clinicController.text, // Add clinic data
        'addressHospital': _addressHospital.text, // Add clinic address data
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
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  /// IMAGEEEEEEEE
  ///
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor\'s Identification'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Doctor\'s Identification Form'),
              TextField(
                controller: _clinicController,
                decoration: InputDecoration(
                  labelText: 'Clinic Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: _addressHospital,
                decoration: InputDecoration(
                  labelText: 'Clinic Address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                  'Please upload your Identification (ID) and Licensure photos.'),
              ElevatedButton(
                onPressed: () {
                  _pickImage(); // Call the function to pick an image from storage
                },
                child: Text('Select Image from Gallery (ID)'),
              ),
              SizedBox(
                height: 20,
              ),
              if (_imageFile != null)
                Image.file(
                  _imageFile!,
                  width: 200,
                  height: 200,
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _pickImage2(); // Call the function to pick an image from storage
                },
                child: Text('Select Image from Gallery (LICENSURE)'),
              ),
              SizedBox(
                height: 20,
              ),
              if (_imageFile2 != null)
                Image.file(
                  _imageFile2!,
                  width: 200,
                  height: 200,
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_imageFile != null && _imageFile2 != null) {
                    // Both images are selected, you can call the registration process here
                    _registerUser(); // Call the registration process
                    uploadImageToFirebase(_imageFile!,
                        widget.userData.email); // Call the image upload process
                  } else {
                    print('Please select both images before registering.');
                  }
                },
                child: Text('Register'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
