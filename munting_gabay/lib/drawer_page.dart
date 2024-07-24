import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/homepage_PT.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/profile_page.dart';
import 'package:munting_gabay/login%20and%20register/changepin_screen.dart';
import 'package:munting_gabay/variable.dart';

import 'main.dart';

class AppDrawer extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AppDrawer({super.key});

  Future<String> getProfileImageUrl() async {
    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('avatars/${_auth.currentUser?.uid ?? 'default'}.jpg');
      String url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      print('Error getting profile image URL: $e');
      return ''; // Return empty string to indicate no URL
    }
  }

  Future<String> getAvatarPath() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .get();
      if (snapshot.exists) {
        return snapshot['avatarPath'] ?? 'assets/images/avatar1.png';
      } else {
        return 'assets/images/avatar1.png';
      }
    } catch (e) {
      print('Error getting avatar path: $e');
      return 'assets/images/avatar1.png'; // Default avatar path
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;
    return Drawer(
      backgroundColor: scaffoldBgColor, // Set the background color to light green
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: secondaryColor, // Dark green for the header
            ),

            accountName: FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user?.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text(
                    'Loading...',
                    style: TextStyle(color: Colors.white),
                  );
                }
                if (snapshot.hasError) {
                  return Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.white),
                  );
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Text(
                    'User not found',
                    style: TextStyle(color: Colors.white),
                  );
                }
                String username = snapshot.data!['username'];
                return Text(' $username',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: 'Roboto', // Change to desired font-family
                  ),
                );
              },
            ),
            accountEmail: const Text(
              "",
              style: TextStyle(color: Colors.white),
            ),
            currentAccountPicture: FutureBuilder<String>(
              future: getProfileImageUrl(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                  // Return default avatar image if error or no URL
                  return CircleAvatar(
                    backgroundImage: AssetImage('assets/images/avatar1.png'),
                  );

                }
                String profileImageUrl = snapshot.data!;
                return CircleAvatar(
                  backgroundImage: NetworkImage(profileImageUrl),
                );

              },
            ),
          ), SizedBox(height: 34,),
          ListTile(
            leading: Icon(Icons.person, color: secondaryColor),
            title: const Text(
              'Profile',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const UserProfilePage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.home_filled, color: secondaryColor),
            title: const Text(
              'Home',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomepagePT()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.pin, color: secondaryColor),
            title: const Text(
              'Change PIN',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ChangePin()),
              );
            },
          ),
          const Divider(color: Colors.black), // Divider color
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text(
                      'Confirm Logout',
                      style: TextStyle(color: Colors.black),
                    ),
                    content: const Text(
                      'Are you sure you want to log out?',
                      style: TextStyle(color: Colors.black),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text(
                          'Logout',
                          style: TextStyle(color: Colors.red),
                        ),
                        onPressed: () async {
                          try {
                            await FirebaseAuth.instance.signOut();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
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
    );
  }
}
