import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:munting_gabay/Doctors%20screen/schedule_request.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/screens/parents%20page/finding%20doctor/MessagePage.dart';

import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/screens/parents%20page/patients_history.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/call.dart';
import 'package:munting_gabay/drawer_page.dart';
import 'package:munting_gabay/login%20and%20register/calling_doctor.dart';
import 'package:munting_gabay/variable.dart';
import 'package:photo_view/photo_view.dart';

import '../../../../ringtone/event_service.dart';
import '../../../../ringtone/flutter_ringtone_player.dart';

class DoctorInfoPage extends StatefulWidget {
  final String docId;
  final String initialName;
  final String NameOfHospital;
  final DateTime birthdate;
  final String initialAddress;
  final String IMAGE;
  final String avatarPath;
  final String currentUserUid;
  final String currentUserName;
  final bool isDoctor;
  final String phoneNumber;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  DoctorInfoPage({
    required this.birthdate,
    required this.phoneNumber,
    required this.avatarPath,
    required this.IMAGE,
    required this.NameOfHospital,
    required this.docId,
    required this.initialName,
    required this.initialAddress,
    required this.currentUserUid,
    required this.currentUserName,
    required this.isDoctor,
  });

  @override
  _DoctorInfoPageState createState() => _DoctorInfoPageState();
}

class _DoctorInfoPageState extends State<DoctorInfoPage> {
  @override
  void initState() {
    super.initState();
    eventBus.on<RingtoneEvent>().listen((event) {
      FlutterRingtonePlayer().playAlarm();
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = 10.1;
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        elevation: 0,
        iconTheme: IconThemeData(color: scaffoldBgColor),
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DOCTORS INFORMATION',
              style: buttonTextStyle1,
            ),
            Container(
              width: double.infinity,
              child: const Divider(
                color: Colors.black,
                thickness: 2.0,
              ),
            ),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly, // Adjust alignment as needed
              children: [
                Card(
                    elevation: 4,
                    margin: const EdgeInsets.all(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          IconButton(
                            color: Colors.pink,
                            icon: const Icon(Icons
                                .calendar_month_rounded), // Scheduling icon
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DoctorScheduleScreen(
                                    docId: widget.docId,
                                  ),
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
                                  builder: (context) => ChatPage(
                                    currentUserUid: widget.currentUserUid,
                                    currentUserName: widget.currentUserName,
                                    // isDoctor: widget.isDoctor,
                                    docId: widget.docId,
                                    recipientName: widget.currentUserName,
                                    senderIsDoctor: false,
                                    recipientIsDoctor: true,
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            width: width,
                          ), // In DocDashboard.dart or equivalent
                          IconButton(
                            icon: const Icon(Icons
                                .video_camera_front_rounded), // Calling icon
                            onPressed: () async {
                              final newCallStatus =
                                  !callStatus; // Toggle call status

                              // Update the callStatus field in Firebase
                              await FirebaseFirestore.instance
                                  .collection(
                                      'usersdata') // Update with your collection name
                                  .doc(widget.docId)
                                  .update({'callStatus': newCallStatus});

                              // Fire the event
                              eventBus.fire(VideoCallEvent(
                                  docId: widget.docId,
                                  isCalling: newCallStatus));

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Call(
                                    currentUserUid: widget.currentUserUid,
                                    currentUserName: widget.currentUserName,
                                    docId: widget.docId,
                                  ),
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
                                  builder: (context) => RequestListScreen(
                                    docId: widget.docId,
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.phone,
                              color: Colors.amber,
                            ), // Icon for phone call
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PhoneCallScreen(
                                    phoneNumber: widget.phoneNumber,
                                    docId: widget.docId,
                                    currentUserName: widget.initialName,
                                  ),
                                ),
                              );
                            },
                          ),

                          SizedBox(
                            width: width,
                          ),
                        ],
                      ),
                    ))
              ],
            ),
            Card(
              elevation: 4,
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
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
                                child: ZoomableImage(widget.avatarPath),
                              ),
                            ),
                          );
                        },
                        child: ClipOval(
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle, // Change to circle shape
                              border: Border.all(
                                color: Colors
                                    .black, // Add a border color if needed
                                width: 2, // Adjust the border width as desired
                              ),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  widget.avatarPath,
                                ),
                              ),
                            ),
                            child: Hero(
                              tag: widget.avatarPath,
                              child: Image.network(
                                widget.avatarPath,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Divider(
                      color: Colors.black,
                      thickness: 2.0,
                    ),
                    SizedBox(
                      height: BtnSpacing,
                    ),
                    Text(
                      'Doctor Email: ${widget.docId}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text('Name: ${widget.initialName}',
                        style: const TextStyle(fontSize: 16)),
                    Text('Address: ${widget.initialAddress}',
                        style: const TextStyle(fontSize: 16)),
                    Text(
                        'Birthdate: ${DateFormat('MMMM d, y').format(widget.birthdate)}',
                        style: const TextStyle(fontSize: 16)),
                    SizedBox(
                      height: BtnSpacing,
                    ),
                    const Text(
                      'CLINIC INFORMATION',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Divider(
                      color: Colors.black,
                      thickness: 2.0,
                    ),
                    Text('Clinic Address: ${widget.NameOfHospital}',
                        style: const TextStyle(fontSize: 16)),
                    Text('Phone Number: ${widget.phoneNumber}',
                        style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ZoomableImage extends StatelessWidget {
  final String imageUrl;

  ZoomableImage(this.imageUrl);

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
