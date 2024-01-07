import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/screens/parents%20page/finding%20doctor/doctor_information.dart';
import 'package:munting_gabay/variable.dart';

import '../../../../drawer_page.dart';

class pscyh extends StatefulWidget {
  @override
  State<pscyh> createState() => _pscyhState();
}

class _pscyhState extends State<pscyh> {
  User? user;
  String? currentEmail;
  String? currentUserName;
  TextEditingController _searchController = TextEditingController();
  late String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    fetchCurrentUser();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchTerm = _searchController.text.toLowerCase();
    });
  }

  Future<void> fetchCurrentUser() async {
    user = FirebaseAuth.instance.currentUser;
    currentEmail = user?.email;

    final userCollection = FirebaseFirestore.instance.collection('users');

    await userCollection.doc(currentEmail).get().then((doc) {
      if (doc.exists) {
        setState(() {
          currentUserName = doc.get('username');
        });
      } else {
        setState(() {
          currentUserName =
              currentEmail; // Use email as the username as a fallback
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: scaffoldBgColor,
        appBar: AppBar(
          backgroundColor: secondaryColor,
          elevation: 0,
          iconTheme: IconThemeData(color: scaffoldBgColor),
          title: Text('Pyschology search'),
        ),
        drawer: AppDrawer(),
        body: SingleChildScrollView(
            child: Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search by Doctor\'s Name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('role', isEqualTo: 'DOCTORS')
                      .where('status', isEqualTo: 'Accepted')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
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
                    }

                    if (!snapshot.hasData) {
                      return Text('No psychologists available.');
                    }

                    // final psychologistDocs = snapshot.data!.docs;
                    final psychologistDocs = snapshot.data!.docs.where((doc) {
                      final psychologistName = (doc.get('name') ?? 'Unknown')
                          .toString()
                          .toLowerCase();
                      return psychologistName.contains(_searchTerm);
                    }).toList();

                    if (psychologistDocs.isEmpty) {
                      return Text(
                          'No psychologists found with the given name.');
                    }
                    return Column(
                      children: psychologistDocs.map((doc) {
                        try {
                          final psychologistName = doc.get('name') ?? 'Unknown';
                          final psychologistAddress =
                              doc.get('address') ?? 'Unknown';

                          return Center(
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  child: Card(
                                    color: secondaryColor,
                                    elevation: 30,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                            radius: 40,
                                            backgroundImage: NetworkImage(
                                              doc['avatarPath'] ?? '',
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
                                                    NameOfHospital: doc.get(
                                                            'addressHospital') ??
                                                        'Unknown',
                                                    IMAGE: doc['avatarPath'] ??
                                                        'assets/images/avatar1.png',
                                                    avatarPath: doc[
                                                            'avatarPath'] ??
                                                        'assets/images/avatar1.png',
                                                    birthdate: doc['birthdate']
                                                        .toDate(),
                                                    currentUserUid:
                                                        currentEmail ?? '',
                                                    currentUserName:
                                                        currentUserName ??
                                                            '', // Pass currentUserName here
                                                    isDoctor: false,
                                                    phone_number:
                                                        doc['phone_number'] ??
                                                            'Unknown',
                                                    DoctorStatus:
                                                        doc['DoctorStatus'] ??
                                                            '',
                                                  ),
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: scaffoldBgColor,
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
            ]))));
  }
}
