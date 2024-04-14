import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:munting_gabay/Doctors%20screen/dr_dashboard.dart';
import 'package:munting_gabay/Dr_Profile.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:munting_gabay/main.dart';
import 'package:munting_gabay/variable.dart';

class DrDrawer extends StatefulWidget {
  const DrDrawer({super.key});

  @override
  State<DrDrawer> createState() => _DrDrawerState();
}

class _DrDrawerState extends State<DrDrawer> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool avail = false;
  bool currentStatus = false;
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
          avatarPath = snapshot['avatarPath'] ?? 'assets/images/avatar1.png';
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
                  return const Text('Loading...');
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Text('User not found');
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
                  return const Center(
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
                  return const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/avatar1.png'),
                  );
                }
                String profileImageUrl = snapshot.data!['avatarPath'];
                return CircleAvatar(
                    backgroundImage: NetworkImage(profileImageUrl));
              },
            ),
          ),

          Row(children: [
            const SizedBox(
              width: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  avail = !avail;
                });
                // Fetch the current status
                DocumentSnapshot userDataSnapshot = await FirebaseFirestore
                    .instance
                    .collection('users')
                    .doc(user?.uid)
                    .get();
                String currentStatus = userDataSnapshot['DoctorStatus'];

                // Toggle the status
                String newStatus = currentStatus == 'Available'
                    ? 'Not Available'
                    : 'Available';

                // Update the status in Firestore
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user?.uid)
                    .update({'DoctorStatus': newStatus});

                // Show a message indicating the status change
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Doctor status changed to $newStatus'),
                ));
              },
              child: Text(avail ? 'Available ' : 'Not Available'),
            ),
            IconButton(
              onPressed: () async {
                // Get the current user's document
                DocumentSnapshot userDataSnapshot = await FirebaseFirestore
                    .instance
                    .collection('users')
                    .doc(user?.uid)
                    .get();

                // Get the current dark mode status
                bool currentStatus = userDataSnapshot['darkmode'] ?? false;

                // Toggle the dark mode status
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user?.uid)
                    .update({'darkmode': !currentStatus});

                // Show a message indicating the status change
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Dark mode toggled'),
                  ),
                );
              },
              icon: Icon(
                currentStatus ? Icons.dark_mode : Icons.light_mode,
                size: 24,
                color: currentStatus ? Colors.black : Colors.yellow,
              ),
            )
          ]),

          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              // Handle navigation to profile
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const DrUserProfile()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.home_filled),
            title: const Text('Home'),
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
          const Divider(
            color: Colors.black,
          ), // Adds a visual divider
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirm Logout'),
                    content: const Text('Are you sure you want to log out?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
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
          // Add more ListTiles for other menu items
        ],
      ),
    );
  }
}
