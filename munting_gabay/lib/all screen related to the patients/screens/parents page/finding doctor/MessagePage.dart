import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

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
        title: Text(widget.doctorName),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: firestore
                  .collection('messages')
                  .doc(widget.doctorId) // Use doctor's ID as the document ID
                  .collection(currentUser
                      .email!) // Use user's email as sub-collection name
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
                  final receiverName = message['receiverName'];

                  messageWidgets.add(
                    ListTile(
                      title: Row(
                        mainAxisAlignment:
                            message['senderId'] == currentUser.email
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: message['senderId'] == currentUser.email
                                    ? Colors.blue
                                    : Colors.green,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    messageText,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(height: 4.0),
                                  Text(
                                    // Format the timestamp to display date and time without seconds
                                    (message['timestamp'] != null &&
                                            message['timestamp'] is Timestamp)
                                        ? DateFormat('yyyy-MM-dd HH:mm').format(
                                            (message['timestamp'] as Timestamp)
                                                .toDate())
                                        : 'N/A',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 12.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      // No subtitle for any message
                      subtitle: null,
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
          .doc(widget.doctorId) // Use doctor's ID as the document ID
          .collection(
              currentUserEmail) // Use user's email as sub-collection name
          .add({
        'senderId': currentUserEmail,
        'senderName': currentUser.displayName, // Store sender's name
        'receiverId': widget.doctorId,
        'receiverName': widget.doctorName, // Store receiver's name
        'messageText': messageText,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Clear the message input field
      messageController.clear();
    } catch (e) {
      // Handle message sending errors here
      print('Error sending message: $e');
    }
  }
}
