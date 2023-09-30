import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewPINScreen extends StatefulWidget {
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
            email: user.email!, password: password);

        await user.reauthenticateWithCredential(credential);

        // Reauthentication successful, retrieve the PIN
        DocumentSnapshot userData = await FirebaseFirestore.instance
            .collection('usersdata')
            .doc(user.email)
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View PIN'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Enter Password',
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                String password = passwordController.text.trim();
                authenticateUser(password);
              },
              child: Text("Submit"),
            ),
            if (isAuthenticated)
              SizedBox(
                height: 20.0,
                child: Text(
                  'Your PIN: $userPIN',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
