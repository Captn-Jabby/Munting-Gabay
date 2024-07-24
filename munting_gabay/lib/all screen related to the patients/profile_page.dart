import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/homepage_PT.dart';
import 'package:munting_gabay/variable.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  late User _currentUser;
  String _avatarPath = '';

  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser!;
    _loadUserData();
  }

  void _loadUserData() async {
    if (_currentUser.uid.isNotEmpty) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser.uid)
          .get();

      if (snapshot.exists) {
        setState(() {
          _nameController.text = snapshot['name'];
          _usernameController.text = snapshot['username'];
          Timestamp birthdateTimestamp = snapshot['birthdate'];
          selectedDate = birthdateTimestamp.toDate();
          _addressController.text = snapshot['address'];
          _emailController.text = snapshot['email'];
          _avatarPath = snapshot['avatarPath'] ?? '';
        });
      }
    } else {
      print('Error: User email is empty');
    }
  }

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
        return day.isBefore(currentDate) || day.isAtSameMomentAs(currentDate);
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _updateUserData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser.uid)
        .update({
      'name': _nameController.text,
      'username': _usernameController.text,
      'birthdate': selectedDate,
      'address': _addressController.text,
      'email': _emailController.text,
      'avatarPath': _avatarPath,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User data updated successfully')),
    );
  }

  Future<void> _showAvatarSelectionDialog() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      await _pickAndUploadAvatar(File(pickedFile.path));
    }
  }

  Future<void> _pickAndUploadAvatar(File file) async {
    final uploadTask = _storage.ref().child('avatars/${_currentUser.uid}.jpg').putFile(file);

    await uploadTask.whenComplete(() async {
      final downloadURL = await _storage.ref().child('avatars/${_currentUser.uid}.jpg').getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser.uid)
          .update({
        'avatarPath': downloadURL,
      });

      setState(() {
        _avatarPath = downloadURL;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Avatar updated successfully')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Background color
      appBar: AppBar(
        backgroundColor: secondaryColor, // AppBar color
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomepagePT(),
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: _showAvatarSelectionDialog,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[300], // Default background color
                  backgroundImage: _avatarPath.isNotEmpty
                      ? NetworkImage(_avatarPath)
                      : null,
                  child: _avatarPath.isEmpty
                      ? Icon(Icons.camera_alt, size: 50, color: Colors.grey[700])
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            _buildTextField(controller: _nameController, label: 'Name'),
            _buildTextField(controller: _usernameController, label: 'Username'),
            const SizedBox(height: 16.0),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: _buildTextField(
                  controller: TextEditingController(text: "${selectedDate.toLocal()}".split(' ')[0]),
                  label: 'Birthdate',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),
            ),
            _buildTextField(controller: _addressController, label: 'Address'),
            _buildTextField(controller: _emailController, label: 'Email', enabled: false),
            const SizedBox(height: 20.0),
            Center(
              child: ElevatedButton(
                onPressed: _updateUserData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryColor, // Button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label, bool enabled = true, Widget? suffixIcon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
