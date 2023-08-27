import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:munting_gabay/Patients%20screens/homepage_PT.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  late User _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser!;
    _loadUserData();
  }

  void _loadUserData() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('usersdata')
        .doc(_currentUser.email)
        .get();

    if (snapshot.exists) {
      setState(() {
        _nameController.text = snapshot['name'];
        _usernameController.text = snapshot['username'];
        _ageController.text = snapshot['age'];
        _addressController.text = snapshot['address'];
        _emailController.text = snapshot['email'];
      });
    }
  }

  void _updateUserData() async {
    await FirebaseFirestore.instance
        .collection('usersdata')
        .doc(_currentUser.email)
        .update({
      'name': _nameController.text,
      'username': _usernameController.text,
      'age': _ageController.text,
      'address': _addressController.text,
      'email': _emailController.text,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User data updated successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Perform your custom action here
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomepagePT()),
            );
          },
        ),
        title: Text('User Profile'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextFormField(
              controller: _ageController,
              decoration: InputDecoration(labelText: 'Age'),
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
            ElevatedButton(
              onPressed: _updateUserData,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
