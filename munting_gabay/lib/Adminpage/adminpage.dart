import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:munting_gabay/Adminpage/admin_drawer.dart';
import 'package:munting_gabay/Doctors%20screen/Dr_drawer.dart';
import 'package:munting_gabay/variable.dart';

import '../../../drawer_page.dart';
import 'doctors_list.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

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
        iconTheme: const IconThemeData(color: BtnColor),
        actions: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

              ],
            ),
          ),
        ],
      ),
      drawer: AdminDrawer(),
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
                  const Text('All'),
                  Radio(
                    value: 'Accepted',
                    groupValue: filter,
                    onChanged: (value) {
                      setState(() {
                        filter = value.toString();
                      });
                    },
                  ),
                  const Text('Accepted'),
                  Radio(
                    value: 'Denied',
                    groupValue: filter,
                    onChanged: (value) {
                      setState(() {
                        filter = value.toString();
                      });
                    },
                  ),
                  const Text('Denied'),
                  Radio(
                    value: 'Waiting',
                    groupValue: filter,
                    onChanged: (value) {
                      setState(() {
                        filter = value.toString();
                      });
                    },
                  ),
                  const Text('Waiting'),
                ],
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('usersdata')
                    .where('usertype', isEqualTo: 'DOCTORS')
                    .snapshots(),
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
                    );
                    ;
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Text('No psychologists available.');
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
                      DateTime birthdate = doc['birthdate'].toDate();
                      String initialBirthdate = birthdate.toLocal().toString();
                      // final clinic = doc['clinic']; // Add clinic data
                      // final addressHospital =
                      //     doc['addressHospital']; // Add clinic address data

                      return Center(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const SizedBox(
                                  width: 100,
                                ),
                                SizedBox(
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
                                            initialBirthdate: initialBirthdate,
                                            initialStatus: psychologistStatus,
                                            // Pass additional user data to the detail screen
                                            clinic: doc['clinic'],
                                            addressHospital:
                                                doc['addressHospital'],

                                            imageUrl:
                                                doc['IDENTIFICATION'] ?? '',
                                            imageUrl2: doc['Licensure'] ?? '',
                                            profilepic: doc['avatarPath'] ?? '',
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: BtnColor,
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
                                          'Status: $psychologistStatus',
                                          style: ParentbuttonTextStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                              color: Colors.black,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
