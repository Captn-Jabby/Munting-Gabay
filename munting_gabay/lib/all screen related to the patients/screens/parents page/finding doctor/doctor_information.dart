import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:munting_gabay/Doctors%20screen/schedule_request.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/screens/parents%20page/finding%20doctor/MessagePage.dart';

import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/screens/parents%20page/patients_history.dart';
import 'package:munting_gabay/call.dart';
import 'package:munting_gabay/drawer_page.dart';
import 'package:munting_gabay/login%20and%20register/calling_doctor.dart';
import 'package:munting_gabay/variable.dart';

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
        return Scaffold(
          backgroundColor: scaffoldBgColor,
          appBar: AppBar(
            backgroundColor: scaffoldBgColor,
            elevation: 0,
            toolbarHeight: 150,
            iconTheme: const IconThemeData(color: BtnColor),
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
                    const SizedBox(width: 60), // Add spacing between images
                    Image.asset(
                      'assets/LOGO.png',
                      height: 150,
                      width: 130,
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),
            ],
          ),
          drawer: AppDrawer(),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'DOCTORS INFORMATION',
                  style: buttonTextStyle,
                ),
                const Divider(
                  color: Colors.black,
                  thickness: 2.0,
                ),
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly, // Adjust alignment as needed
                  children: [
                    IconButton(
                      color: Colors.pink,
                      icon: const Icon(
                          Icons.calendar_month_rounded), // Scheduling icon
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
                              docId: widget.docId, recipientName: widget.currentUserName,
                              senderIsDoctor: false, recipientIsDoctor: true,
                            ),
                          ),
                        );
                      },
                    ),
                    // In DocDashboard.dart or equivalent
                    IconButton(
                      icon: const Icon(Icons.call_end), // Calling icon
                      onPressed: () async {
                        final newCallStatus = !callStatus; // Toggle call status

                        // Update the callStatus field in Firebase
                        await FirebaseFirestore.instance
                            .collection('usersdata') // Update with your collection name
                              .doc(widget.docId)
                            .update({'callStatus': newCallStatus});

                        // Fire the event
                        eventBus.fire(VideoCallEvent(docId: widget.docId, isCalling: newCallStatus));

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

                    IconButton(
                  icon: const Icon(Icons.lock_clock), // Calling icon
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
              ],
            ),
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(
                widget.avatarPath, // Use the avatarPath from the widget
              ),
            ),
            SizedBox(
              height: BtnSpacing,
            ),
            Text('Doctor Email: ${widget.docId}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text('Name: ${widget.initialName}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Text('Address: ${widget.initialAddress}',
                style: const TextStyle(fontSize: 16)),
            Text(
                'Birthdate: ${DateFormat('MMMM d, y').format(widget.birthdate)}',
                style: const TextStyle(fontSize: 16)),
            const Text(
              'CLINIC INFORMATION',
              style: buttonTextStyle,
            ),
            const Divider(
              color: Colors.black,
              thickness: 2.0,
            ),
            Text('Clinic  Address: ${widget.NameOfHospital}',
                style: const TextStyle(fontSize: 16)),
            SizedBox(
              height: BtnSpacing,
            ),
            Text('phone Number: ${widget.phoneNumber}',
                style: const TextStyle(fontSize: 16)),
            SizedBox(height: BtnSpacing),
            SizedBox(height: BtnSpacing),
          ],
        ),
      ),
    );
  }
}
