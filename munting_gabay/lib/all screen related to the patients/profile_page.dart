import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:munting_gabay/Doctors%20screen/dr_dashboard.dart';
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
  // final Box<String> _avatarBox = Hive.box<String>('avatarBox');
  String _avatarPath = '';

  final FirebaseStorage _storage =
      FirebaseStorage.instance; // Instantiate FirebaseStorage

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser!;
    // _avatarPath =
    //     _avatarBox.get('avatarPath${_currentUser.email}', defaultValue: '')!;
    _loadUserData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUserData();
  }

  void _loadUserData() async {
    if (_currentUser.uid!.isNotEmpty) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser.uid)
          .get();

      if (snapshot.exists) {
        setState(() {
          _nameController.text = snapshot['name'];
          _usernameController.text = snapshot['username'];
          // Convert Timestamp to DateTime
          Timestamp birthdateTimestamp = snapshot['birthdate'];
          selectedDate = birthdateTimestamp.toDate();
          _addressController.text = snapshot['address'];
          _emailController.text = snapshot['email'];
          _avatarPath = snapshot['avatarPath'] ?? '';
          // 'https://firebasestorage.googleapis.com/v0/b/munting-gabay-4f845.appspot.com/o/avatars%2Fbened8ct12%40gmail.com.jpg?alt=media&token=0d9e85c8-bcf3-4789-986c-caeda85e16ce';
        });
      }
    } else {
      print('Error: User email is empty');
      // Handle the case where user email is empty
    }
  }

  // void _updateAvatarPath(String path) {
  //   print("Avatar Path: $_avatarPath"); // Add this line for debugging

  //   _avatarBox.put('avatarPath${_currentUser.email}', path);
  // }

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

  void _updateUserData() async {
    print("Avatar Path: $_avatarPath"); // Add this line for debugging

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

  // Function to display avatar selection dialog
  Future<void> _showAvatarSelectionDialog() async {
    final selectedAvatar = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return Column(
          children: [
            SimpleDialog(
              title: const Text('Select Avatar'),
              children: <Widget>[
                SimpleDialogOption(
                  onPressed: () async {
                    // Close the dialog
                    Navigator.pop(context);

                    // Pick and upload a new avatar
                    await _pickAndUploadAvatar();
                  },
                  child: const ListTile(
                    title: Text('Choose from Gallery'),
                  ),
                ),
                // Add more SimpleDialogOption for additional avatars
              ],
            ),
          ],
        );
      },
    );

    if (selectedAvatar != null) {
      setState(() {
        _avatarPath = selectedAvatar;
        // _updateAvatarPath(_avatarPath); // Update avatar path in Hive
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Avatar Path: $_avatarPath"); // Add this line for debugging
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: Text('Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomepagePT(),
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _showAvatarSelectionDialog,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(_avatarPath),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextField(
                  controller: TextEditingController(
                      text: "${selectedDate.toLocal()}"
                          .split(' ')[0]), // Format to show only the date part
                  decoration: InputDecoration(
                    labelText: 'Birthdate',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
              ),
            ),
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email', enabled: false),
            ),
            SizedBox(height: 16.0),
            Container(
              // width: BtnWidth,
              // height: BtnHeight,
              child: ElevatedButton(
                onPressed: _updateUserData,
                child: Text(
                  'Save',
                  style: buttonTextStyle1,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryColor, // Use the specified color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(BtnCircularRadius),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickAndUploadAvatar() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Upload the image to Firebase Storage
      Reference storageReference =
          _storage.ref().child('avatars/${_currentUser.uid}.jpg');
      UploadTask uploadTask = storageReference.putFile(File(pickedFile.path));
      await uploadTask.whenComplete(() async {
        // Get the download URL of the uploaded image
        String downloadURL = await storageReference.getDownloadURL();

        // Update the avatar path in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_currentUser.uid)
            .update({
          'avatarPath': downloadURL,
        });

        // Update the local state
        setState(() {
          _avatarPath = downloadURL;
        });

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Avatar updated successfully')),
        );
      });
    }
  }
}
