import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/screens/parents%20page/finding%20doctor/MessagePage.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/call.dart';
import 'package:munting_gabay/variable.dart';

import '../../../../Doctors screen/doctor_call.dart';

class UserSelectionPage extends StatelessWidget {
  Future<List<DocumentSnapshot>> fetchUsers() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    return querySnapshot.docs;
  }

  Future<String> getCurrentUserEmail() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    return currentUser?.email ?? '';
  }

  Future<String> getCurrentUserName(String currentEmail) async {
    final userCollection = FirebaseFirestore.instance.collection('users');
    DocumentSnapshot userDoc = await userCollection.doc(currentEmail).get();

    if (userDoc.exists) {
      return userDoc.get('name') ?? '';
    } else {
      return currentEmail; // Use email as the username as a fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: Text('Select User to Message'),
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: Center(
              child: CircularProgressIndicator(
                // Color of the loading indicator
                valueColor: AlwaysStoppedAnimation<Color>(LoadingColor),

                // Width of the indicator's line
                strokeWidth: 4,

                // Optional: Background color of the circle
                backgroundColor: bgloadingColor,
              ),
            ));
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No users available.'),
            );
          }
          List<DocumentSnapshot> users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index].data() as Map<String, dynamic>;
              var userName =
                  user['name'] ?? 'Unknown Name'; // Use a default name if null
              var userId =
                  users[index].id ?? 'Unknown ID'; // Use a default ID if null;

              return FutureBuilder<String>(
                future: getCurrentUserEmail(),
                builder: (context, emailSnapshot) {
                  if (emailSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        // Color of the loading indicator
                        valueColor: AlwaysStoppedAnimation<Color>(LoadingColor),

                        // Width of the indicator's line
                        strokeWidth: 4,

                        // Optional: Background color of the circle
                        backgroundColor: bgloadingColor,
                      ),
                    );
                    ;
                  }

                  if (emailSnapshot.hasError) {
                    return Center(
                      child: Text('Error: ${emailSnapshot.error}'),
                    );
                  }

                  final currentEmail = emailSnapshot.data ?? '';

                  return FutureBuilder<String>(
                    future: getCurrentUserName(currentEmail),
                    builder: (context, nameSnapshot) {
                      if (nameSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            // Color of the loading indicator
                            valueColor:
                                AlwaysStoppedAnimation<Color>(LoadingColor),

                            // Width of the indicator's line
                            strokeWidth: 4,

                            // Optional: Background color of the circle
                            backgroundColor: bgloadingColor,
                          ),
                        );
                        ;
                      }

                      if (nameSnapshot.hasError) {
                        return Center(
                          child: Text('Error: ${nameSnapshot.error}'),
                        );
                      }

                      final currentUserName = nameSnapshot.data ?? '';

                      return Column(
                        children: [
                          ListTile(
                            title: Text(
                              '$userName',
                              textScaleFactor: 1.5,
                            ),
                            onTap: () {
                              String senderUid = currentEmail;
                              String senderName = currentUserName;
                              bool senderIsDoctor =
                                  true; // Assuming the sender is a doctor

                              String recipientUid = userId;
                              String recipientName = userName;
                              bool recipientIsDoctor =
                                  true; // Assuming the recipient is a doctor

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatPage(
                                    currentUserUid: senderUid,
                                    currentUserName: senderName,
                                    docId: recipientUid,
                                    recipientName: recipientName,
                                    recipientIsDoctor: recipientIsDoctor,
                                    senderIsDoctor: senderIsDoctor,
                                  ),
                                ),
                              );
                            },
                          ),
                          Divider(),
                        ],
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
