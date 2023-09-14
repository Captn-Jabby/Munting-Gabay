import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:munting_gabay/Dr_Profile.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/profile_page.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:hive/hive.dart';
import 'package:munting_gabay/login%20and%20register/changepin_screen.dart';
import 'package:munting_gabay/main.dart';

class DrDrawer extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;
    String? profileImageUrl;

    // Function to retrieve the profile image URL from Firebase Storage
    Future<void> getProfileImageUrl() async {
      try {
        final ref = firebase_storage.FirebaseStorage.instance.ref().child(
            'profile_images/${user?.uid}.jpg'); // Adjust the path as needed
        profileImageUrl = await ref.getDownloadURL();
      } catch (e) {
        print('Error getting profile image URL: $e');
      }
    }

    // Call the function to get the profile image URL
    getProfileImageUrl();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('usersdata')
                  .doc(user?.email)
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
            accountEmail: Text(user?.email ?? ""),
            currentAccountPicture: CircleAvatar(
              backgroundImage: profileImageUrl != null
                  ? NetworkImage(profileImageUrl!)
                  : AssetImage(
                      // Use the avatar path from Hive as the default
                      Hive.box<String>('avatarBox').get(
                          'avatarPath${user?.email}',
                          defaultValue: 'assets/A.png')!,
                    ) as ImageProvider<Object>,
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              // Handle navigation to profile
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => DrUserProfile()),
              );
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.settings),
          //   title: Text('Settings'),
          //   onTap: () {
          //     // Navigator.pushReplacement(
          //     //   context,
          //     //   MaterialPageRoute(builder: (context) => ChnagePin()),
          //     // );
          //   },
          // ),
          Divider(
            color: Colors.black,
          ), // Adds a visual divider
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Confirm Logout'),
                    content: Text('Are you sure you want to log out?'),
                    actions: <Widget>[
                      Text('Dr Drawer'),
                      TextButton(
                        child: Text('Cancel'),
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
