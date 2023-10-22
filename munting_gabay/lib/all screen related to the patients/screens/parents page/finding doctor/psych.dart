import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/screens/parents%20page/finding%20doctor/docinfo.dart';
import 'package:munting_gabay/variable.dart';

import '../../../../drawer_page.dart';

class pscyh extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: scaffoldBgColor,
        elevation: 0,
        toolbarHeight: 150,
        iconTheme: IconThemeData(color: BtnColor),
        actions: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/A.png', // Replace with the path to your first image
                  width: 130,
                  height: 150,
                ),
                SizedBox(width: 60), // Add spacing between images
                Image.asset(
                  'assets/LOGO.png',
                  height: 150,
                  width: 130,
                ),
                SizedBox(width: 40),
              ],
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  // ... (search container)
                  ),
              SizedBox(height: 50),
              Container(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('usersdata')
                      .where('usertype', isEqualTo: 'DOCTORS')
                      .where('status', isEqualTo: 'Accepted')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    if (!snapshot.hasData) {
                      return Text('No psychologists available.');
                    }

                    final psychologistDocs = snapshot.data!.docs;
                    return Column(
                      children: psychologistDocs.map((doc) {
                        try {
                          final psychologistName = doc.get('name') ?? 'Unknown';
                          final psychologistAddress =
                              doc.get('address') ?? 'Unknown';

                          return Center(
                            child: Column(
                              children: [
                                Card(
                                  elevation: 3,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          radius: 40,
                                          backgroundImage: AssetImage(
                                            doc['avatarPath'] ??
                                                'assets/avatar1.png',
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'Name: $psychologistName',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Text(
                                          'Address: $psychologistAddress',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        SizedBox(height: 10),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DoctorInfoPage(
                                                  docId: doc.id,
                                                  initialName: doc['name'],
                                                  initialAddress:
                                                      doc['address'],
                                                ),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.blue,
                                            onPrimary: Colors.white,
                                          ),
                                          child: Text(
                                            'View Details',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          );
                        } catch (e) {
                          print('Error in rendering psychologist: $e');
                          return SizedBox
                              .shrink(); // Return an empty container in case of error
                        }
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
