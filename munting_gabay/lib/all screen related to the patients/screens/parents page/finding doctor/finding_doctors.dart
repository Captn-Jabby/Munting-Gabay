import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/screens/parents%20page/finding%20doctor/doctor_information.dart';
import 'package:munting_gabay/variable.dart';

import '../../../../drawer_page.dart';

class pscyh extends StatefulWidget {
  const pscyh({super.key});

  @override
  State<pscyh> createState() => _pscyhState();
}

class _pscyhState extends State<pscyh> {
  User? user;
  String? currentEmail;
  String? currentUserName;
  final TextEditingController _searchController = TextEditingController();
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
    currentEmail = user?.uid;

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
        centerTitle: true,
        title: const Text('Finding Doctors'),
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
                  decoration: const InputDecoration(
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
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
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
                      return const Text('No psychologists available.');
                    }

                    // final psychologistDocs = snapshot.data!.docs;
                    final psychologistDocs = snapshot.data!.docs.where((doc) {
                      final psychologistName = (doc.get('name') ?? 'Unknown')
                          .toString()
                          .toLowerCase();
                      return psychologistName.contains(_searchTerm);
                    }).toList();

                    if (psychologistDocs.isEmpty) {
                      return const Text(
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
                                SizedBox(
                                  width: double.infinity,
                                  child: Card(
                                    color: secondaryColor,
                                    elevation: 30,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                            radius: 40,
                                            backgroundImage: NetworkImage(
                                              doc['profile_picture'] ?? '',
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            'Name: $psychologistName',
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                          Text(
                                            'Address: $psychologistAddress',
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                          const SizedBox(height: 10),
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
                                                            'clinic_address') ??
                                                        'Unknown',
                                                    IMAGE: doc[
                                                            'profile_picture'] ??
                                                        'assets/images/avatar1.png',
                                                    avatarPath: doc[
                                                            'profile_picture'] ??
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
                                                        doc['status'] ?? '',
                                                  ),
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              backgroundColor: scaffoldBgColor,
                                            ),
                                            child: Text('View Details',
                                                style: buttonText1),
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
                          return const SizedBox
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
