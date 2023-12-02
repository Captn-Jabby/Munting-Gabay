// In call.dart file
import 'package:flutter/material.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/screens/parents%20page/finding%20doctor/finding_doctors.dart';
import 'package:munting_gabay/call/models/agora_connection_data.dart';
import 'package:munting_gabay/call/src/agora_client.dart'
    as callAgoraClient; // Rename to avoid conflict
import 'package:munting_gabay/call/src/buttons/buttons.dart';
import 'package:munting_gabay/call/src/enums.dart';
import 'package:munting_gabay/call/src/layout/layout.dart';
import 'package:munting_gabay/variable.dart';

class CallDoctor extends StatefulWidget {
  const CallDoctor({
    Key? key,
    required this.currentUserUid,
    required this.currentemailId,
    required this.currentUserName,
    required this.docId,
  }) : super(key: key);
  final String currentemailId;
  final String currentUserUid;
  final String currentUserName;
  final String docId;

  @override
  State<CallDoctor> createState() => _CallDoctorState();
}

class _CallDoctorState extends State<CallDoctor> {
  late final callAgoraClient.AgoraClient client;
  // bool reverseOrder = true; // Set to true or false based on your condition

  // String generateChannelName() {
  //   if (reverseOrder) {
  //     return widget.docId + widget.currentUserUid;
  //   } else {
  //     return widget.currentUserUid + widget.docId;
  //   }
  // }

  @override
  void initState() {
    super.initState();

    client = callAgoraClient.AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: "ce045b781cb94043a99410d2a476fadd",
        channelName: widget.currentUserUid + widget.docId,
        username: widget.currentUserName,
      ),
      currentUserUid: widget.currentUserUid,
      currentUserName: widget.currentUserName,
      docId: widget.docId,
    );

    initAgora();
  }

  void initAgora() async {
    client.initialize(
      appId: "ce045b781cb94043a99410d2a476fadd",
      channelName: widget.currentUserUid + widget.docId,
      username: widget.currentUserName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: const Text('VIDEO DOCTOR SIDE CALL'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            AgoraVideoViewer(
              client: client,
              layoutType: Layout.floating,
              enableHostControls: true,
            ),
            AgoraVideoButtons(
              client: client,
              addScreenSharing: false,
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Username: ${widget.currentUserName}'),
                    Text('Doc ID: ${widget.docId}'),
                    Text(
                        'Channel Name: ${client.agoraConnectionData.channelName}'),
                    Text('Channel uid: ${client.agoraConnectionData.username}')
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
