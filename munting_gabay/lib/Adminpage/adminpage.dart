import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:munting_gabay/variable.dart';

import '../../../drawer_page.dart';
import 'doctors_list.dart';

class AdminPage extends StatefulWidget {
  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  String filter = 'All'; // Default filter value

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
              // ... (other widgets)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio(
                    value: 'All',
                    groupValue: filter,
                    onChanged: (value) {
                      setState(() {
                        filter = value.toString();
                      });
                    },
                  ),
                  Text('All'),
                  Radio(
                    value: 'Accepted',
                    groupValue: filter,
                    onChanged: (value) {
                      setState(() {
                        filter = value.toString();
                      });
                    },
                  ),
                  Text('Accepted'),
                  Radio(
                    value: 'Denied',
                    groupValue: filter,
                    onChanged: (value) {
                      setState(() {
                        filter = value.toString();
                      });
                    },
                  ),
                  Text('Denied'),
                  Radio(
                    value: 'Waiting',
                    groupValue: filter,
                    onChanged: (value) {
                      setState(() {
                        filter = value.toString();
                      });
                    },
                  ),
                  Text('Waiting'),
                ],
              ),
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

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Text('No psychologists available.');
                    }

                    final psychologistDocs = snapshot.data!.docs;
                    List<QueryDocumentSnapshot> filteredPsychologists =
                        psychologistDocs;

                    if (filter != 'All') {
                      filteredPsychologists = psychologistDocs
                          .where((doc) =>
                              doc['status'] == filter) // Filter based on status
                          .toList();
                    }

                    return Column(
                      children: filteredPsychologists.map((doc) {
                        final psychologistName = doc['name'];
                        final psychologistAddress = doc['address'];
                        final psychologistStatus = doc['status'];

                        return Center(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 115,
                                  ),
                                  Container(
                                    width: BtnWidth,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DoctorDetailsScreen(
                                              docId: doc.id,
                                              initialName: doc['name'],
                                              initialAddress: doc['address'],
                                              initialAge: doc['age'],
                                              initialStatus: psychologistStatus,
                                            ),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                       backgroundColor: secondaryColor,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Name: $psychologistName',
                                            style: ParentbuttonTextStyle,
                                          ),
                                          Text(
                                            'Address: $psychologistAddress',
                                            style: ParentbuttonTextStyle,
                                          ),
                                          Text(
                                            'Status: $psychologistStatus',
                                            style: ParentbuttonTextStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
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
