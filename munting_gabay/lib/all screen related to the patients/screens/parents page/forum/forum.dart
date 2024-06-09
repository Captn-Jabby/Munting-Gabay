import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ForumPage extends StatelessWidget {
  const ForumPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Munting Gabay Forum'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Navigate to the screen/modal for creating a new post
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewPostScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PostList(),
          ),
        ],
      ),
    );
  }
}

class PostList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final posts = snapshot.data!.docs;
        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index] as QueryDocumentSnapshot<Map<String, dynamic>>;
            return PostTile(post: post);
          },
        );
      },
    );
  }
}

class PostTile extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> post;

  const PostTile({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int upvotes = post.data().containsKey('upvotes') ? post['upvotes'] ?? 0 : 0;

    return Card(
      margin: const EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CommentPage(post: post),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post['content'] ?? '',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Posted by: ${post['userId'] ?? "Anonymous"}',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          // Handle upvote
                          FirebaseFirestore.instance.runTransaction((transaction) async {
                            final freshSnapshot = await transaction.get(post.reference);
                            final upvotes = freshSnapshot.data()!.containsKey('upvotes') ? freshSnapshot['upvotes'] ?? 0 : 0;
                            transaction.update(post.reference, {'upvotes': upvotes + 1});
                          });
                        },
                        icon: Icon(Icons.arrow_upward),
                      ),
                      Text('$upvotes'),
                    ],
                  ),
                ],
              ),
              // Always show edit and delete buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      // Handle edit
                    },
                    icon: Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () {
                      // Handle delete
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Delete Post'),
                            content: Text('Are you sure you want to delete this post?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  post.reference.delete();
                                  Navigator.of(context).pop();
                                },
                                child: Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.delete),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CommentPage extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> post;

  const CommentPage({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post['content'] ?? ''),
      ),
      body: Column(
        children: [
          Expanded(
            child: CommentList(post: post),
          ),
          CommentInput(post: post),
        ],
      ),
    );
  }
}

class CommentList extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> post;

  const CommentList({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('comments')
          .where('postId', isEqualTo: post.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final comments = snapshot.data!.docs;
        return ListView.builder(
          itemCount: comments.length,
          itemBuilder: (context, index) {
            final comment = comments[index];
            return ListTile(
              title: Text(comment['content'] ?? ''),
              subtitle: Text(comment['userId'] ?? ''),
            );
          },
        );
      },
    );
  }
}

class CommentInput extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> post;
  final TextEditingController _commentController = TextEditingController();

  CommentInput({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Add a comment...',
              ),
            ),
          ),
          IconButton(
            onPressed: () async {
              // Handle comment submission
              String username = 'Anonymous'; // Default username
              final currentUser = FirebaseAuth.instance.currentUser;
              if (currentUser != null) {
                final userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
                if (userDoc.exists) {
                  // Extract username
                  username = userDoc.data()?['username'] ?? 'Anonymous';
                }
              }

              FirebaseFirestore.instance.collection('comments').add({
                'postId': post.id,
                'userId': username,
                'content': _commentController.text,
                'timestamp': FieldValue.serverTimestamp(),
              });
              _commentController.clear();
            },
            icon: Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}

class NewPostScreen extends StatefulWidget {
  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final TextEditingController _postController = TextEditingController();
  bool _useAnonymous = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _postController,
              decoration: InputDecoration(
                hintText: 'Write your post...',
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: _useAnonymous,
                  onChanged: (value) {
                    setState(() {
                      _useAnonymous = value!;
                    });
                  },
                ),
                Text('Post Anonymously'),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                // Handle post submission
                final content = _postController.text;
                if (content.isNotEmpty) {
                  String username;
                  if (_useAnonymous) {
                    username = 'Anonymous';
                  } else {
                    // Get current user
                    final User? currentUser = FirebaseAuth.instance.currentUser;
                    if (currentUser != null) {
                      // Fetch user document from Firestore
                      final userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
                      if (userDoc.exists) {
                        // Extract username
                        username = userDoc.data()?['username'] ?? 'Anonymous';
                      } else {
                        username = 'Anonymous';
                      }
                    } else {
                      username = 'Anonymous';
                    }
                  }
                  // Add post
                  FirebaseFirestore.instance.collection('posts').add({
                    'userId': username,
                    'content': content,
                    'timestamp': FieldValue.serverTimestamp(),
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
