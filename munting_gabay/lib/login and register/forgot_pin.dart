import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:munting_gabay/variable.dart';

class ViewPINScreen extends StatefulWidget {
  const ViewPINScreen({super.key});

  @override
  _ViewPINScreenState createState() => _ViewPINScreenState();
}

class _ViewPINScreenState extends State<ViewPINScreen> {
  final TextEditingController passwordController = TextEditingController();
  String? userPIN;
  bool isAuthenticated = false;

  Future<void> authenticateUser(String password) async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );

        await user.reauthenticateWithCredential(credential);

        // Reauthentication successful, retrieve the PIN
        DocumentSnapshot userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userData.exists) {
          final Map<String, dynamic> userDataMap =
              userData.data() as Map<String, dynamic>;
          final String userPIN = userDataMap['pin'];

          setState(() {
            this.userPIN = userPIN;
            isAuthenticated = true;
          });
        }
      }
    } catch (e) {
      // Handle authentication errors (e.g., incorrect password)
      print("Authentication error: $e");
      // Show error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Authentication Failed'),
            content: const Text('Incorrect password. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: const Text('View PIN'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Enter Password',
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryColor, // Change this color to the desired background color
              ),
              onPressed: () {
                String password = passwordController.text.trim();
                authenticateUser(password);
              },
              child: const Text(
                "Submit",
                style: TextStyle(color: text),
              ),
            ),
            if (isAuthenticated)
              SizedBox(
                height: 20.0,
                child: Text(
                  'Your PIN: $userPIN',
                  style: const TextStyle(fontSize: 18.0),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
