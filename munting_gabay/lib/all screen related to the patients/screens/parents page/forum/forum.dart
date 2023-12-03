import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:munting_gabay/variable.dart';

class ForumPage extends StatefulWidget {
  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User? _user;
  late TextEditingController _postController;
  late TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _postController = TextEditingController();
    _commentController = TextEditingController();
    _user = _auth.currentUser;
  }

  Future<void> _signOut() async {
    await _auth.signOut();
    setState(() {
      _user = null;
    });
  }

  Future<void> _signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      setState(() {
        _user = _auth.currentUser;
      });
    } catch (e) {
      print(e);
    }
  }

  void createPost(String content) async {
    String userName = 'Anonymous User';
    DocumentSnapshot userSnapshot =
        await _firestore.collection('usersdata').doc(_user?.uid).get();
    if (userSnapshot.exists) {
      userName = (userSnapshot.data() as Map)['name'] ?? 'Anonymous User';
    }
    DocumentReference postRef = await _firestore.collection('posts').add({
      'userId': userName,
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
    });
    String postId = postRef.id;
    postRef.update({'postId': postId});
  }

  void addComment(String postId, String userId, String content) async {
    String userName = 'Anonymous User';
    DocumentSnapshot userSnapshot =
        await _firestore.collection('usersdata').doc(_user?.uid).get();
    if (userSnapshot.exists) {
      userName = (userSnapshot.data() as Map)['name'] ?? 'Anonymous User';
    }
    _firestore.collection('comments').add({
      'postId': postId,
      'userId': userName,
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  void _showPostModal(String postId, String postContent, String userName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Set to true to ensure the modal is not full height
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: MediaQuery.of(context).size.height *
                0.6, // Adjust the height of the modal
            child: PostModal(
              postId: postId,
              postContent: postContent,
              userName: userName,
              user: _user,
              firestore: _firestore,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: Text('Munting Gabay Forum'),
      ),
      body: _user == null
          ? Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary:
                      BtnColor, // Change this color to the desired background color
                ),
                onPressed: () => _signIn('test@example.com', 'password'),
                child: Text('Sign in as a test user'),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore.collection('posts').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
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
                          ),
                        );
                      }
                      final posts = snapshot.data!.docs;
                      List<Widget> postWidgets = [];
                      for (var post in posts) {
                        final postContent = post.get('content');
                        final userName = post.get('userId');
                        final postWidget = ListTile(
                          title: Text(postContent),
                          subtitle: Text(userName),
                          trailing: IconButton(
                            icon: Icon(Icons.add_comment),
                            onPressed: () {
                              _showPostModal(post.id, postContent, userName);
                            },
                          ),
                        );
                        postWidgets.add(postWidget);
                      }
                      return ListView(
                        children: postWidgets,
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _postController,
                    decoration: InputDecoration(
                      hintText: 'Write your post...',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          createPost(_postController.text);
                          _postController.clear();
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class PostModal extends StatefulWidget {
  final String postId;
  final String postContent;
  final String userName;
  final User? user;
  final FirebaseFirestore firestore;

  const PostModal({
    required this.postId,
    required this.postContent,
    required this.userName,
    required this.user,
    required this.firestore,
  });

  @override
  _PostModalState createState() => _PostModalState();
}

class _PostModalState extends State<PostModal> {
  late TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
  }

  void addComment(String content) async {
    String userName = 'Anonymous User';
    DocumentSnapshot userSnapshot = await widget.firestore
        .collection('usersdata')
        .doc(widget.user?.email)
        .get();
    if (userSnapshot.exists) {
      userName = (userSnapshot.data() as Map)['name'] ?? 'Anonymous User';
    }
    widget.firestore.collection('comments').add({
      'postId': widget.postId,
      'userId': userName,
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.postContent}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(height: 8.0),
          Text(widget.userName),
          SizedBox(height: 16.0),
          Container(
            height: 100.0,
            child: StreamBuilder<QuerySnapshot>(
              stream: widget.firestore
                  .collection('comments')
                  .where('postId', isEqualTo: widget.postId)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Center(
                      child: CircularProgressIndicator(
                        // Color of the loading indicator
                        valueColor: AlwaysStoppedAnimation<Color>(LoadingColor),

                        // Width of the indicator's line
                        strokeWidth: 4,

                        // Optional: Background color of the circle
                        backgroundColor: bgloadingColor,
                      ),
                    ),
                  );
                }
                final comments = snapshot.data!.docs;
                List<Widget> commentWidgets = [];
                for (var comment in comments) {
                  final commentContent = comment.get('content');
                  final commentedUserName = comment.get('userId');
                  final commentWidget = ListTile(
                    title: Text(commentContent),
                    subtitle: Text('Commented by $commentedUserName'),
                  );
                  commentWidgets.add(Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: commentWidget,
                  ));
                }
                return ListView(
                  children: commentWidgets,
                );
              },
            ),
          ),
          SizedBox(height: 16.0),
          TextFormField(
            controller: _commentController,
            decoration: InputDecoration(
              hintText: 'Write a comment...',
            ),
          ),
          SizedBox(height: 8.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary:
                  BtnColor, // Change this color to the desired background color
            ),
            onPressed: () {
              addComment(_commentController.text);
              _commentController.clear();
            },
            child: Text('Add Comment'),
          ),
        ],
      ),
    );
  }
}
