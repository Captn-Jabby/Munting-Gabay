// In call.dart file
import 'package:flutter/material.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/screens/parents%20page/finding%20doctor/finding_doctors.dart';
import 'package:munting_gabay/call/models/agora_connection_data.dart';
import 'package:munting_gabay/call/src/agora_client.dart'
    as callAgoraClient; // Rename to avoid conflict
import 'package:munting_gabay/call/src/buttons/buttons.dart';
import 'package:munting_gabay/call/src/enums.dart';
import 'package:munting_gabay/call/src/layout/layout.dart';

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
        channelName: 'test', // Default channel name, update as needed
        username: 'user', // Default username, update as needed
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
      channelName: widget.docId,
      username: widget.currentUserName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VIDEO CALL'),
        centerTitle: true,
        actions: [
          ElevatedButton(
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
                    Text('Username: ${widget.currentUserName}'),
                    Text('Doc ID: ${widget.docId}'),
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
// import 'package:agora_uikit/agora_uikit.dart';
// import 'package:flutter/material.dart';

// void main() {
//   runApp(call());
// }

// class call extends StatefulWidget {
//   const call({Key? key}) : super(key: key);

//   @override
//   State<call> createState() => _callState();
// }

// class _callState extends State<call> {
//   final AgoraClient client = AgoraClient(
//     agoraConnectionData: AgoraConnectionData(
//       appId: "ce045b781cb94043a99410d2a476fadd",
//       channelName: "test",
//       username: "user",
//     ),
//   );

//   @override
//   void initState() {
//     super.initState();
//     initAgora();
//   }

//   void initAgora() async {
//     await client.initialize();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('sadsad VideoUIKit'),
//           centerTitle: true,
//         ),
//         body: SafeArea(
//           child: Stack(
//             children: [
//               AgoraVideoViewer(
//                 client: client,
//                 layoutType: Layout.floating,
//                 enableHostControls: true, // Add this to enable host controls
//               ),
//               AgoraVideoButtons(
//                 client: client,
//                 addScreenSharing: false, // Add this to enable screen sharing
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
