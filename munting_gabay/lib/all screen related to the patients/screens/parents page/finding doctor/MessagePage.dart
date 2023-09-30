import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatPage extends StatefulWidget {
  final String doctorId; // Doctor's UID
  final String doctorName; // Doctor's name

  ChatPage({required this.doctorId, required this.doctorName});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.doctorName),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: firestore
                  .collection('messages')
                  .doc(widget.doctorId)
                  .collection('chats')
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
                  final messageSender = message['senderId'];

                  messageWidgets.add(
                    ListTile(
                      title: Text(messageText),
                      subtitle: Text(messageSender),
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
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final String currentUserId = user.uid;

        final CollectionReference messagesCollection =
            firestore.collection('messages');

        // Create a new message document
        await messagesCollection.doc(widget.doctorId).collection('chats').add({
          'senderId': currentUserId,
          'messageText': messageText,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Clear the message input field
        messageController.clear();
      }
    } catch (e) {
      // Handle message sending errors here
      print('Error sending message: $e');
    }
  }
}
