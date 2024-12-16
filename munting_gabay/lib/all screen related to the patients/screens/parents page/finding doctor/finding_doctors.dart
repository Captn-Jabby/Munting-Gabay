import 'package:flutter/material.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/screens/parents%20page/finding%20doctor/doctor_information.dart';
import 'package:munting_gabay/variable.dart';
import 'package:provider/provider.dart';

import '../../../../models/doctor.dart';
import '../../../../providers/doctor_provider.dart';

class FindingDoctorsScreen extends StatefulWidget {
  const FindingDoctorsScreen({super.key});

  @override
  State<FindingDoctorsScreen> createState() => _FindingDoctorsScreenState();
}

class _FindingDoctorsScreenState extends State<FindingDoctorsScreen> {
  late final DoctorProvider doctorProvider;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    doctorProvider = Provider.of<DoctorProvider>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    doctorProvider.clearSearchKey();
    _searchController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        elevation: 0,
        centerTitle: true,
        title: const Text('Finding Doctors'),
      ),
      // drawer: AppDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by Doctor\'s Name',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    doctorProvider.setSearchKey(key: "");
                    _searchController.clear();
                  },
                  icon: const Icon(Icons.clear),
                ),
              ),
              onChanged: (key) => doctorProvider.setSearchKey(key: key),
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
            ),
          ),
          const SizedBox(height: 10),
          Consumer<DoctorProvider>(
            builder: (context, provider, child) {
              final List<Doctor> doctors = provider.getFilteredDoctors;
              final String searchKey = provider.getSearchKey;

              if (provider.isDoctorLoading) {
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
              }

              if (doctors.isEmpty && searchKey.isEmpty) {
                return const Center(
                  child: Text("No doctors found."),
                );
              }

              if (searchKey.isNotEmpty && doctors.isEmpty) {
                return const Center(
                  child: Text("No doctors found with the provided name."),
                );
              }

              return Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: doctors.map(
                      (doc) {
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
                                            doc.profilePicture,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          'Name: ${doc.name}',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        Text(
                                          'Address: ${doc.address}',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(height: 10),
                                        ElevatedButton(
                                          onPressed: () {
                                            provider.setSelectedDoctor(
                                              doctor: doc,
                                            );

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DoctorInfoPage(),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor: scaffoldBgColor,
                                          ),
                                          child: Text(
                                            'View Details',
                                            style: buttonText1,
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
                      },
                    ).toList(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
