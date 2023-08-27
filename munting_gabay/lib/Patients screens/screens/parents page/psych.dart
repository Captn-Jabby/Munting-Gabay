import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:munting_gabay/variable.dart';

import '../../../drawer_page.dart';

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
                        final psychologistName = doc['name'];
                        final psychologistAddress = doc['address'];

                        return Center(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  // ... (Image and spacing widgets)
                                  SizedBox(
                                    width: 115,
                                  ),
                                  Container(
                                    width: BtnWidth,
                                    height: BtnHeight,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          BtnCircularRadius),
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // TODO: Implement button functionality
                                        print('Psychologist button pressed!');
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.blue,
                                        onPrimary: Colors.white,
                                      ),
                                      child: Text(
                                        '$psychologistName\n$psychologistAddress',
                                        style: ParentbuttonTextStyle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                color: Colors.black,
                              ),
                            ],
                          ),
                        );
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
