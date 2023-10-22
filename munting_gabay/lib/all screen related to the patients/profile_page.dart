import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/homepage_PT.dart';

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
  final Box<String> _avatarBox = Hive.box<String>('avatarBox');
  late String _avatarPath;

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser!;
    _avatarPath = _avatarBox.get('avatarPath${_currentUser.email}',
        defaultValue: 'assets/avatar1.png')!;
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
        // Convert Timestamp to DateTime
        Timestamp birthdateTimestamp = snapshot['birthdate'];
        selectedDate = birthdateTimestamp.toDate();
        _addressController.text = snapshot['address'];
        _emailController.text = snapshot['email'];
        _avatarPath = _avatarBox.get('avatarPath${_currentUser.email}',
            defaultValue: snapshot['avatarPath'] ?? 'assets/avatar1.png')!;
      });
    }
  }

  void _updateAvatarPath(String path) {
    _avatarBox.put('avatarPath${_currentUser.email}', path);
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

  void _updateUserData() async {
    await FirebaseFirestore.instance
        .collection('usersdata')
        .doc(_currentUser.email)
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
                  onPressed: () {
                    Navigator.pop(context,
                        'assets/avatar1.png'); // Update with your avatar asset path
                  },
                  child: const ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(
                          'assets/avatar1.png'), // Update with your avatar asset path
                    ),
                    title: Text('Avatar 1'),
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context,
                        'assets/avatar2.png'); // Update with your avatar asset path
                  },
                  child: const ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(
                          'assets/avatar2.png'), // Update with your avatar asset path
                    ),
                    title: Text('Avatar 2'),
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context,
                        'assets/avatar3.png'); // Update with your avatar asset path
                  },
                  child: const ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(
                          'assets/avatar3.png'), // Update with your avatar asset path
                    ),
                    title: Text('Avatar 3'),
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context,
                        'assets/avatar4.png'); // Update with your avatar asset path
                  },
                  child: const ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(
                          'assets/avatar4.png'), // Update with your avatar asset path
                    ),
                    title: Text('Avatar 4'),
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
        _updateAvatarPath(_avatarPath); // Update avatar path in Hive
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Perform your custom action here
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomepagePT()),
            );
          },
        ),
        title: const Text('User Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _showAvatarSelectionDialog,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage(_avatarPath),
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 16.0),
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
              decoration: const InputDecoration(labelText: 'Address'),
            ),
            TextFormField(
              controller: _emailController,
              decoration:
                  const InputDecoration(labelText: 'Email', enabled: false),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _updateUserData,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
