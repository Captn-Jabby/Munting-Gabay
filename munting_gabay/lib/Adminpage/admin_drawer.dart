import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:munting_gabay/Adminpage/admin_profile.dart';
import 'package:munting_gabay/Adminpage/adminpage.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:munting_gabay/main.dart';
import 'package:munting_gabay/variable.dart';

class AdminDrawer extends StatelessWidget {
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
            .doc(user?.uid)
            .get();

        if (snapshot.exists) {
          avatarPath =
              snapshot['avatarPath'] ?? 'assets/images/images/avatar1.png';
        }
      } catch (e) {
        print('Error getting data from Firebase: $e');
      }
    }

    // Call the function to get data from Firebase

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user?.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Loading...');
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Text('User not found');
                }
                String username = snapshot.data!['username'];
                return Text(username);
              },
            ),
            accountEmail: Text(user?.uid ?? ""),
            currentAccountPicture: FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user?.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      // Color of the loading indicator
                      valueColor: AlwaysStoppedAnimation<Color>(LoadingColor),

                      // Width of the indicator's line
                      strokeWidth: 4,

                      // Optional: Background color of the circle
                      backgroundColor: bgloadingColor,
                    ),
                  ); // Show a loading indicator
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                String profileImageUrl = snapshot.data!['avatarPath'];
                return CircleAvatar(
                    backgroundImage: NetworkImage(profileImageUrl));
              },
            ),
          ),

          ListTile(
            leading: Icon(Icons.person),
            title: Text(
              'Profile',
              style: TextStyle(color: Colors.black54),
            ),
            onTap: () {
              // Handle navigation to profile
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AdminProfilePage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.home_filled),
            title: Text(
              'Home',
              style: TextStyle(color: Colors.black54),
            ),
            onTap: () {
              // Handle navigation to profile
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AdminPage()),
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
              style: TextStyle(color: Colors.black54),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      'Confirm Logout',
                      style: TextStyle(color: Colors.black54),
                    ),
                    content: Text(
                      'Are you sure you want to log out?',
                      style: TextStyle(color: Colors.black54),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.black54),
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
          // Add more ListTiles for other menu items
        ],
      ),
    );
  }
}
