import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/screens/parents%20page/patients_history.dart';
import 'package:munting_gabay/login%20and%20register/calling_doctor.dart';
import 'package:munting_gabay/variable.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

import '../../../../providers/doctor_provider.dart';
import 'chat_page.dart';
import 'doctor_schedule.dart';

class DoctorInfoPage extends StatefulWidget {
  const DoctorInfoPage({super.key});

  @override
  _DoctorInfoPageState createState() => _DoctorInfoPageState();
}

class _DoctorInfoPageState extends State<DoctorInfoPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = 10.1;
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: const Text('Doctor Information'),
      ),
      body: Consumer<DoctorProvider>(
        builder: (context, provider, child) {
          final doctor = provider.getSelectedDoctor!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DOCTORS INFORMATION',
                  style: buttonTextStyle12.copyWith(color: Colors.black87),
                ),
                const SizedBox(
                  width: double.infinity,
                  child: Divider(
                    color: Colors.black,
                    thickness: 2.0,
                  ),
                ),
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          color: Colors.pink,
                          icon: const Icon(
                              Icons.calendar_month_rounded), // Scheduling icon
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const DoctorScheduleScreen(),
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          width: width,
                        ),
                        IconButton(
                          icon: const Icon(Icons.message), // Messaging icon
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ChatPage(),
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          width: width,
                        ),
                        IconButton(
                          icon: const Icon(Icons.history), // Calling icon
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RequestListScreen(),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.phone,
                            color: Colors.amber,
                          ), // Icon for phone call
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PhoneCallScreen(),
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          width: width,
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: BtnSpacing,
                        ),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Container(
                                    color: Colors.red,
                                    child: ZoomableImage(doctor.profilePicture),
                                  ),
                                ),
                              );
                            },
                            child: ClipOval(
                              child: Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  shape:
                                      BoxShape.circle, // Change to circle shape
                                  border: Border.all(
                                    color: Colors
                                        .black, // Add a border color if needed
                                    width:
                                        2, // Adjust the border width as desired
                                  ),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      doctor.profilePicture,
                                    ),
                                  ),
                                ),
                                child: Hero(
                                  tag: doctor.profilePicture,
                                  child: Image.network(
                                    doctor.profilePicture,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: BtnSpacing),
                        Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _getStatusColor(doctor.status),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              doctor.status,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: _getStatusColor(doctor.status),
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          color: Colors.black,
                          thickness: 2.0,
                        ),
                        const SizedBox(
                          height: BtnSpacing,
                        ),
                        Text(
                          'Email: ${doctor.email}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Name: ${doctor.name}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Address: ${doctor.address}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Birthdate: ${DateFormat('MMMM d, y').format(doctor.birthdate)}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(
                          height: BtnSpacing,
                        ),
                        const Text(
                          'CLINIC INFORMATION',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(
                          color: Colors.black,
                          thickness: 2.0,
                        ),
                        Text(
                          'Clinic Address: ${doctor.clinicAddress}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Phone Number: ${doctor.phoneNumber}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    if (status == 'Available') {
      return Colors.green;
    } else if (status == 'Not Available') {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }
}

class ZoomableImage extends StatelessWidget {
  final String imageUrl;

  const ZoomableImage(this.imageUrl, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
      ),
      body: Center(
        child: Hero(
          tag: imageUrl,
          child: PhotoView(
            imageProvider: NetworkImage(imageUrl),
          ),
        ),
      ),
    );
  }
}
