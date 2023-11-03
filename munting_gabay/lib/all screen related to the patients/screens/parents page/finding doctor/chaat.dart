// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class ChatPage extends StatefulWidget {
//   final String currentUserUid; // User's UID
//   final String currentUserName; // User's name
//   final String docId; // Chat document ID
//   final String recipientName; // Recipient's name
//   final bool senderIsDoctor; // Indicates if the sender is a doctor
//   final bool recipientIsDoctor; // Indicates if the recipient is a doctor

//   ChatPage({
//     required this.currentUserUid,
//     required this.currentUserName,
//     required this.docId,
//     required this.recipientName,
//     required this.senderIsDoctor,
//     required this.recipientIsDoctor,
//   });

//   @override
//   _ChatPageState createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   final TextEditingController messageController = TextEditingController();
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//   late User currentUser;
//   String chatDocId = ''; // Variable to store chat document ID

//   @override
//   void initState() {
//     super.initState();
//     // Get the current authenticated user
//     currentUser = FirebaseAuth.instance.currentUser!;
//     // Generate chat document ID
//     chatDocId = widget.senderIsDoctor
//         ? 'chat_${widget.currentUserUid}_${widget.docId}'
//         : 'chat_${widget.docId}_${widget.currentUserUid}';
//   }

//   void sendMessage(String messageText) async {
//     try {
//       final String currentUserUid = widget.currentUserUid;

//       final CollectionReference messagesCollection =
//           firestore.collection('chats/$chatDocId/messages');

//       await messagesCollection.add({
//         'sender': currentUserUid,
//         'text': messageText,
//         'timestamp': FieldValue.serverTimestamp(),
//       });

//       // Clear the message input field
//       messageController.clear();
//     } catch (e) {
//       print('Error sending message: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.recipientName),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: firestore
//                   .collection('chats/$chatDocId/messages')
//                   .orderBy('timestamp')
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }

//                 final List<QueryDocumentSnapshot> documents =
//                     snapshot.data!.docs;

//                 return ListView.builder(
//                   itemCount: documents.length,
//                   itemBuilder: (context, index) {
//                     final message = documents[index];
//                     final messageText = message['text'];
//                     final senderId = message['sender'];
//                     final isCurrentUser = senderId == currentUser.uid;
//                     final senderRole = isCurrentUser
//                         ? widget.senderIsDoctor
//                             ? 'Doctor'
//                             : 'Patient'
//                         : widget.senderIsDoctor
//                             ? 'Patient'
//                             : 'Doctor';

//                     final bubbleColor =
//                         isCurrentUser ? Colors.green : Colors.blue;

//                     return ListTile(
//                       title: Row(
//                         mainAxisAlignment: isCurrentUser
//                             ? MainAxisAlignment.end
//                             : MainAxisAlignment.start,
//                         children: [
//                           Flexible(
//                             child: Container(
//                               padding: EdgeInsets.all(8.0),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(8.0),
//                                 color: bubbleColor,
//                               ),
//                               child: Text(
//                                 messageText,
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       subtitle: Text('$senderRole'),
//                       trailing: null,
//                       leading: null,
//                       contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: messageController,
//                     decoration: InputDecoration(
//                       hintText: 'Type your message...',
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send, color: Colors.red),
//                   onPressed: () async {
//                     sendMessage(messageController.text);
//                   },
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
