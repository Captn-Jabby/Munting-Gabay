import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReceiverChatPage extends StatefulWidget {
  final String receiverId; // Receiver's UID
  final String receiverName; // Receiver's name

  ReceiverChatPage({required this.receiverId, required this.receiverName});

  @override
  _ReceiverChatPageState createState() => _ReceiverChatPageState();
}

class _ReceiverChatPageState extends State<ReceiverChatPage> {
  final TextEditingController messageController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late User currentUser;

  @override
  void initState() {
    super.initState();
    // Get the current authenticated user
    currentUser = FirebaseAuth.instance.currentUser!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverName),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: firestore
                  .collection('messages')
                  .doc(
                      widget.receiverId) // Use receiver's ID as the document ID
                  .collection(currentUser
                      .email!) // Use current user's email as the sub-collection name
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final List<DocumentSnapshot> documents = snapshot.data!.docs;

                List<Widget> messageWidgets = [];

                for (var message in documents) {
                  final messageText = message['messageText'];
                  final senderName = message['senderName'];

                  messageWidgets.add(
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .start, // Align messages to the left for the receiver
                        children: [
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Colors
                                    .green, // You can customize the color for receiver's messages
                              ),
                              child: Text(
                                messageText,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text(
                          'From: $senderName'), // Display sender's name under the message
                      // No trailing widget for any message
                      trailing: null,
                      // No leading widget for any message
                      leading: null,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                  );
                }

                return ListView(
                  children: messageWidgets,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    sendMessage(messageController.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void sendMessage(String messageText) async {
    try {
      // Get the current authenticated user's email
      final String currentUserEmail = currentUser.email!;

      final CollectionReference messagesCollection =
          firestore.collection('messages');

      // Create a new message document in the receiver's collection
      await messagesCollection
          .doc(widget.receiverId) // Use receiver's ID as the document ID
          .collection(
              currentUserEmail) // Use current user's email as the sub-collection name
          .add({
        'senderId': currentUserEmail,
        'senderName': currentUser.displayName, // Store sender's name
        'receiverId': widget.receiverId,
        'receiverName': widget.receiverName, // Store receiver's name
        'messageText': messageText,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Create a copy of the message in the sender's collection
      // await messagesCollection
      //     .doc(currentUserEmail) // Use sender's email as the document ID
      //     .collection(
      //         widget.receiverId) // Use receiver's ID as the sub-collection name
      //     .add({
      //   'senderId': currentUserEmail,
      //   'senderName': currentUser.displayName, // Store sender's name
      //   'receiverId': widget.receiverId,
      //   'receiverName': widget.receiverName, // Store receiver's name
      //   'messageText': messageText,
      //   'timestamp': FieldValue.serverTimestamp(),
      // });

      // Clear the message input field
      messageController.clear();
    } catch (e) {
      // Handle message sending errors here
      print('Error sending message: $e');
    }
  }
}
