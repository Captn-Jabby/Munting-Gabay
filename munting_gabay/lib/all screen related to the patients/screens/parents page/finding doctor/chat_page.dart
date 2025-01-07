import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:munting_gabay/variable.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../models/current_user.dart';
import '../../../../models/doctor.dart';
import '../../../../providers/current_user_provider.dart';
import '../../../../providers/doctor_provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
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

  Future<void> getChatDocId(CurrentUser currentUser, Doctor doctor) async {
    await firestore
        .collection("chats")
        .where("participants", arrayContains: currentUser.id)
        .get()
        .then(
      (value) async {
        // get conversation id
        if (value.docs.isNotEmpty) {
          final key = value.docs.indexWhere((e) =>
              e.get("participants").contains(currentUser.id) &&
              e.get("participants").contains(doctor.id));

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
  }

  void sendMessage(CurrentUser currentUser, Doctor doctor, String messageText,
      String messageType) async {
    try {
      final String currentUserUid = currentUser.id;
      DateTime timestamp = DateTime.timestamp();

      // create conversation first and/or store latest message sent
      if (chatDocId == "") {
        chatDocId = await firestore.collection("chats").add({
          "last_sender": currentUserUid,
          "last_message": messageType == "image" ? "Sent a photo" : messageText,
          "last_message_time": timestamp,
          "participants": [currentUser.id, doctor.id],
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
  void sendImageMessage(
      CurrentUser currentUser, Doctor doctor, String imageUrl) {
    sendMessage(currentUser, doctor, imageUrl, 'image');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CurrentUserProvider, DoctorProvider>(
      builder: (context, currentUserProvider, doctorProvider, child) {
        final doctor = doctorProvider.getSelectedDoctor!;
        final currentUser = currentUserProvider.currentUser!;
        final width = MediaQuery.of(context).size.width;

        return Scaffold(
          backgroundColor: scaffoldBgColor,
          appBar: AppBar(
            backgroundColor: secondaryColor,
            titleSpacing: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  foregroundImage: NetworkImage(doctor.profilePicture),
                ),
                const SizedBox(width: 12),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.name,
                      style: Theme.of(context).textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      doctor.status,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: FutureBuilder<void>(
                  future: getChatDocId(currentUser, doctor),
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
                                .limit(100)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    // Color of the loading indicator
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        LoadingColor),

                                    // Width of the indicator's line
                                    strokeWidth: 4,

                                    // Optional: Background color of the circle
                                    backgroundColor: bgloadingColor,
                                  ),
                                );
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
                                  final isCurrentUser =
                                      senderName == currentEmail;

                                  // Debug prints
                                  print(
                                      'Sender: $senderName, Is Current User: $isCurrentUser');

                                  return ListTile(
                                    title: Align(
                                      alignment: isCurrentUser
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: Container(
                                        constraints: BoxConstraints(
                                          minWidth: message["type"] == 'image'
                                              ? width * 0.65
                                              : width * 0.20,
                                          minHeight: message["type"] == 'image'
                                              ? width * 0.20
                                              : 0,
                                          maxWidth: width * 0.65,
                                        ),
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
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
                                                message['text'],
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
                                          timeago.format(
                                              message["timestamp"].toDate()),
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
                          sendImageMessage(currentUser, doctor, imageUrl);
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.cyan,
                      ),
                      onPressed: () async {
                        sendMessage(
                          currentUser,
                          doctor,
                          messageController.text,
                          'text',
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
