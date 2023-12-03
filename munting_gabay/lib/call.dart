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

class Call extends StatefulWidget {
  const Call({
    Key? key,
    required this.currentUserUid,
    required this.currentUserName,
    required this.docId,
  }) : super(key: key);

  final String currentUserUid;
  final String currentUserName;
  final String docId;

  @override
  State<Call> createState() => _CallState();
}

class _CallState extends State<Call> {
  late final callAgoraClient.AgoraClient client;

  @override
  void initState() {
    super.initState();
    client = callAgoraClient.AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: "ce045b781cb94043a99410d2a476fadd",
        channelName: widget.currentUserUid +
            widget.docId, // Default channel name, update as needed
        username: widget.currentUserUid, // Default username, update as needed
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
        title: const Text('VIDEO CALL'),
        centerTitle: true,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary:
                  BtnColor, // Change this color to the desired background color
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => pscyh(),
                ),
              );
            },
            child: Text('.'),
          ),
        ],
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
                    Text(
                      'Username: ${widget.currentUserName}',
                      style: TextStyle(color: text),
                    ),
                    Text(
                      'Doc ID: ${widget.docId}',
                      style: TextStyle(color: text),
                    ),
                    Text(
                      'Channel Name: ${client.agoraConnectionData.channelName}',
                      style: TextStyle(color: text),
                    ),
                    Text(
                      'Channel username: ${client.agoraConnectionData.username}',
                      style: TextStyle(color: text),
                    ),
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
