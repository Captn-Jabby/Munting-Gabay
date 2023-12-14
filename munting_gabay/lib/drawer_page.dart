import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:munting_gabay/Adminpage/adminpage.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/homepage_PT.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/profile_page.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:munting_gabay/darltheme.dart';
import 'package:munting_gabay/login%20and%20register/changepin_screen.dart';
import 'package:munting_gabay/variable.dart';

import 'main.dart';

class AppDrawer extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;
    String? profileImageUrl;
    String? avatarPath;

    Future<void> getDataFromFirebase() async {
      try {
        // Retrieve the profile image URL
        final ref = firebase_storage.FirebaseStorage.instance
            .ref()
            .child('avatars${user?.uid}.jpg');
        profileImageUrl = await ref.getDownloadURL();

        // Retrieve the avatar path
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user?.email)
            .get();

        if (snapshot.exists) {
          avatarPath = snapshot['avatarPath'] ?? 'assets/images/avatar1.png';
        }
      } catch (e) {
        print('Error getting data from Firebase: $e');
      }
    }

    // Call the function to get data from Firebase

    return Drawer(
      child: Container(
        color: scaffoldBgColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              color: scaffoldBgColor,
              child: UserAccountsDrawerHeader(
                accountName: FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(user?.email)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text(
                        'Loading...',
                        style: TextStyle(color: text),
                      );
                    }
                    if (snapshot.hasError) {
                      return Text(
                        'Error: ${snapshot.error}',
                        style: TextStyle(color: text),
                      );
                    }
                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return Text(
                        'User not found',
                        style: TextStyle(color: text),
                      );
                    }
                    String username = snapshot.data!['username'];
                    return Text(username);
                  },
                ),
                accountEmail: Text(user?.email ?? ""),
                currentAccountPicture: FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(user?.email)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Show a loading indicator
                    }
                    if (snapshot.hasError) {
                      return Text(
                        'Error: ${snapshot.error}',
                        style: TextStyle(color: text),
                      );
                    }
                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return CircleAvatar(
                        backgroundImage: AssetImage('assets/avatar1.png'),
                      );
                    }
                    String profileImageUrl = snapshot.data!['avatarPath'];
                    return CircleAvatar(
                        backgroundImage: NetworkImage(profileImageUrl));
                  },
                ),
              ),
            ),

            Column(
              children: [
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text(
                    'Profile',
                    style: TextStyle(color: text),
                  ),
                  onTap: () {
                    // Handle navigation to profile
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserProfilePage()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.home_filled),
                  title: Text(
                    'Home',
                    style: TextStyle(color: text),
                  ),
                  onTap: () {
                    // Handle navigation to profile
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomepagePT()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text(
                    'Settings',
                    style: TextStyle(color: text),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => ChangePin()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.color_lens),
                  title: Text(
                    'Themes',
                    style: TextStyle(color: text),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ColorChangerScreen()),
                    );
                  },
                ),
                Divider(
                  color: Colors.black,
                ), // Adds a visual divider
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text(
                    'Logout',
                    style: TextStyle(color: text),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            'Confirm Logout',
                            style: TextStyle(color: text),
                          ),
                          content: Text(
                            'Are you sure you want to log out?',
                            style: TextStyle(color: text),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text(
                                'Cancel',
                                style: TextStyle(color: text),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                            ),
                            TextButton(
                              child: Text(
                                'Logout',
                                style: TextStyle(color: Colors.red),
                              ),
                              onPressed: () async {
                                try {
                                  await FirebaseAuth.instance.signOut();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()),
                                  );
                                } catch (e) {
                                  print('Error logging out: $e');
                                }
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),

            // Add more ListTiles for other menu items
          ],
        ),
      ),
    );
  }
}
