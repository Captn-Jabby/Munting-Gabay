import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:munting_gabay/variable.dart';

class ChatPage extends StatefulWidget {
  final String currentUserUid; // User's UID
  final String currentUserName; // User's name
  final String docId; // Chat document ID
  final String recipientName; // Recipient's name
  final bool senderIsDoctor; // Indicates if the sender is a doctor
  final bool recipientIsDoctor; // Indicates if the recipient is a doctor

  const ChatPage({
    super.key,
    required this.currentUserUid,
    required this.currentUserName,
    required this.docId,
    required this.recipientName,
    required this.senderIsDoctor,
    required this.recipientIsDoctor,
  });

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late User currentUser;
  String chatDocId = ''; // Variable to store chat document ID
  bool hasError = false;

  Future<void> getChatDocId() async {
    await firestore
        .collection("chats")
        .where("participants", arrayContains: widget.currentUserUid)
        .get()
        .then(
      (value) async {
        // get conversation id
        if (value.docs.isNotEmpty) {
          final key = value.docs.indexWhere((e) =>
              e.get("participants").contains(widget.currentUserUid) &&
              e.get("participants").contains(widget.docId));

          chatDocId = key > -1 ? value.docs[key].id : "";
        }
      },
    ).catchError((err) {
      print(err);
      hasError = true;
    });
  }

  @override
  void initState() {
    super.initState();
    // Get the current authenticated user
    currentUser = FirebaseAuth.instance.currentUser!;
    // // Generate chat document ID
    // chatDocId = widget.senderIsDoctor
    //     ? 'chat_${widget.currentUserUid}_${widget.docId}'
    //     : 'chat_${widget.docId}_${widget.currentUserUid}';
  }

  void sendMessage(String messageText, String messageType) async {
    try {
      final String currentUserUid = widget.currentUserUid;
      DateTime timestamp = DateTime.timestamp();

      // create conversation first and/or store latest message sent
      if (chatDocId == "") {
        chatDocId = await firestore.collection("chats").add({
          "last_sender": currentUserUid,
          "last_message": messageType == "image" ? "Sent a photo" : messageText,
          "last_message_time": timestamp,
          "participants": [widget.currentUserUid, widget.docId],
        }).then((chat) => chat.id);

        setState(() {});
      } else {
        await firestore.collection("chats").doc(chatDocId).update({
          "last_sender": currentUserUid,
          "last_message": messageType == "image" ? "Sent a photo" : messageText,
          "last_message_time": timestamp,
        });
      }

      final CollectionReference messagesCollection =
          firestore.collection('chats/$chatDocId/messages');

      await messagesCollection.add({
        'sender': currentUserUid,
        'text': messageText,
        'type': messageType,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Clear the message input field
      messageController.clear();
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  // Function to send an image message
  void sendImageMessage(String imageUrl) {
    sendMessage(imageUrl, 'image');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: Text(widget.recipientName),
        // actions: [
        //   ElevatedButton.icon(
        //       style: ElevatedButton.styleFrom(
        //         backgroundColor: scaffoldBgColor, // Change this color to the desired background color
        //       ),
        //       onPressed: () {
        //         print("userUID ${widget.currentUserUid}");
        //         print("docID ${widget.docId}");
        //         print("NAME ${widget.recipientName}}");
        //         Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //             builder: (context) => CallDoctor(
        //               currentUserUid: widget.currentUserUid,
        //               currentUserName: widget.currentUserUid,
        //               docId: widget.docId,
        //               currentemailId: widget.recipientName,
        //             ),
        //           ),
        //         );
        //       },
        //       icon: const Icon(Icons.call_made),
        //       label: const Text('call'))
        // ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<void>(
              future: getChatDocId(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Text("Fetching conversation..."),
                  );
                }
                if (hasError) {
                  return const Center(
                    child: Text("Error fetching conversation"),
                  );
                }
                return chatDocId == ""
                    ? const Center(
                        child: Text("Start new conversation."),
                      )
                    : StreamBuilder<QuerySnapshot>(
                        stream: firestore
                            .collection('chats/$chatDocId/messages')
                            .orderBy('timestamp', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: Center(
                              child: CircularProgressIndicator(
                                // Color of the loading indicator
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(LoadingColor),

                                // Width of the indicator's line
                                strokeWidth: 4,

                                // Optional: Background color of the circle
                                backgroundColor: bgloadingColor,
                              ),
                            ));
                          }

                          final List<QueryDocumentSnapshot> documents =
                              snapshot.data!.docs;

                          final currentEmail =
                              FirebaseAuth.instance.currentUser?.uid;

                          return ListView.builder(
                            reverse: true,
                            itemCount: documents.length,
                            itemBuilder: (context, index) {
                              final message = documents[index];
                              final messageType = message['type'];
                              final senderName = message['sender'];
                              final isCurrentUser = senderName == currentEmail;

                              // Debug prints
                              print(
                                  'Sender: $senderName, Is Current User: $isCurrentUser');

                              return ListTile(
                                title: Align(
                                  alignment: isCurrentUser
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: isCurrentUser
                                          ? Colors.blue
                                          : Colors.grey,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (messageType == 'text')
                                          Text(
                                            message['text'],
                                            style: TextStyle(
                                              color: isCurrentUser
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          )
                                        else if (messageType == 'image')
                                          Image.network(
                                            message[
                                                'text'], // Assuming 'text' contains the image URL
                                            width:
                                                200, // Adjust the size as needed
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: isCurrentUser
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      senderName,
                                      style: TextStyle(
                                        color: isCurrentUser
                                            ? Colors.grey
                                            : Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                              );
                            },
                          );
                        },
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
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.camera,
                    color: Colors.cyan,
                  ),
                  onPressed: () async {
                    final imagePicker = ImagePicker();
                    final imageFile = await imagePicker.pickImage(
                        source: ImageSource.gallery);

                    if (imageFile != null) {
                      // Implement image upload to Firebase Storage
                      final imageUrl =
                          await uploadImageToFirebase(imageFile.path);

                      // Send the image message with the obtained image URL
                      sendImageMessage(imageUrl);
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Colors.cyan,
                  ),
                  onPressed: () async {
                    sendMessage(messageController.text, 'text');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<String> uploadImageToFirebase(String imagePath) async {
    // Use Firebase Storage or any other cloud storage service to upload the image
    // Replace the code below with your actual image upload logic
    // Example using Firebase Storage:
    final storageReference =
        FirebaseStorage.instance.ref().child('images/${DateTime.now()}.jpg');
    final uploadTask = storageReference.putFile(File(imagePath));
    final snapshot = await uploadTask.whenComplete(() => null);
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
