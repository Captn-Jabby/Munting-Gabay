import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/profile_page.dart';
import 'package:munting_gabay/login%20and%20register/changepin_screen.dart';
import 'package:munting_gabay/variable.dart';
import 'package:provider/provider.dart';

import 'providers/current_user_provider.dart';

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
    // final User? user = _auth.currentUser;
    return Drawer(
      backgroundColor:
          scaffoldBgColor, // Set the background color to light green
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Consumer<CurrentUserProvider>(
            builder: (context, currentUser, child) {
              return UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: secondaryColor, // Dark green for the header
                ),
                accountName: Text(
                  currentUser.currentUser?.username ?? "Unknown User",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: 'Roboto', // Change to desired font-family
                  ),
                ),
                accountEmail: Text(
                  currentUser.currentUser?.email ?? "",
                  style: const TextStyle(color: Colors.white),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundImage:
                      NetworkImage(currentUser.currentUser?.avatarPath ?? ""),
                ),
              );
            },
          ),
          const SizedBox(
            height: 34,
          ),
          ListTile(
            leading: Icon(Icons.person, color: secondaryColor),
            title: const Text(
              'Profile',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserProfilePage(),
                ),
              );

              Scaffold.of(context).closeDrawer();
            },
          ),
          ListTile(
            leading: Icon(Icons.home_filled, color: secondaryColor),
            title: const Text(
              'Home',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Navigator.popUntil(
                context,
                (route) => route.isFirst,
              );

              Scaffold.of(context).closeDrawer();
            },
          ),
          ListTile(
            leading: Icon(Icons.pin, color: secondaryColor),
            title: const Text(
              'Change PIN',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangePin(),
                ),
              );

              Scaffold.of(context).closeDrawer();
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
                            Navigator.pop(context);
                            await FirebaseAuth.instance.signOut().then(
                                  (value) => Navigator.popUntil(
                                    context,
                                    (route) => route.isFirst,
                                  ),
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
