// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/screens/parents%20page/finding%20doctor/MessagePage.dart';

// class ConversationList extends StatefulWidget {
//   final String currentUserEmail;

//   ConversationList({required this.currentUserEmail});

//   @override
//   _ConversationListState createState() => _ConversationListState();
// }

// class _ConversationListState extends State<ConversationList> {
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: firestore
//             .collection('chats')
//             .doc(widget
//                 .currentUserEmail) // Use the current user's email as the document ID
//             .collection(
//                 'messages') // Assuming conversations are stored in a subcollection
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }

//           final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

//           return ListView.builder(
//             itemCount: documents.length,
//             itemBuilder: (context, index) {
//               final conversation = documents[index];
//               final recipientEmail = conversation
//                   .id; // Use the document ID as the recipient's email

//               return ListTile(
//                 title: Text('Chat with $recipientEmail'),
//                 onTap: () {
//                   // Open the chat page for this conversation
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ChatPage(
//                         currentUserUid: 'widget.currentUserEmail',
//                         currentUserName: '',
//                         docId: 'widget.currentUserEmail',
//                         recipientName: '',
//                         senderIsDoctor: true,
//                         recipientIsDoctor: true, AMaDoctor: true,

//                         // Add other necessary parameters
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
