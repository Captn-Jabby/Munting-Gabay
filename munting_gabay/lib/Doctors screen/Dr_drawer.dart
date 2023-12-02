import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:munting_gabay/Adminpage/adminpage.dart';
import 'package:munting_gabay/Doctors%20screen/dr_dashboard.dart';
import 'package:munting_gabay/Dr_Profile.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/homepage_PT.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/profile_page.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:munting_gabay/login%20and%20register/changepin_screen.dart';
import 'package:munting_gabay/main.dart';
import 'package:munting_gabay/variable.dart';

class DrDrawer extends StatelessWidget {
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
            .collection('usersdata')
            .doc(user?.email)
            .get();

        if (snapshot.exists) {
          avatarPath = snapshot['avatarPath'] ?? 'assets/avatar1.png';
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
            currentAccountPicture: FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('usersdata')
                  .doc(user?.email)
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
          ListTile(
            leading: Icon(Icons.home_filled),
            title: Text('Home'),
            onTap: () {
              // Handle navigation to profile
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => DocDashboard(
                          docId: '',
                        )),
              );
            },
          ),
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
