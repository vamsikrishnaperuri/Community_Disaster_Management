import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/post_model.dart';
import 'post_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Post> posts = [];
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('posts').get();
      setState(() {
        posts = snapshot.docs.map((doc) {
          return Post.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();
      });
    } catch (e) {
      print('Error fetching posts: $e');
    }
  }

  Future<void> updateVote(String postId, bool isUpvote) async {
    if (user == null) {
      return;
    }

    DocumentReference postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
    DocumentReference voteRef = postRef.collection('votes').doc(user!.uid);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot postSnapshot = await transaction.get(postRef);
      DocumentSnapshot voteSnapshot = await transaction.get(voteRef);

      if (postSnapshot.exists) {
        int currentUpvotes = postSnapshot['upvotes'] ?? 0;
        int currentDownvotes = postSnapshot['downvotes'] ?? 0;

        if (voteSnapshot.exists) {
          String existingVote = voteSnapshot['voteType'];

          if ((isUpvote && existingVote == 'upvote') || (!isUpvote && existingVote == 'downvote')) {
            return;
          } else {
            if (isUpvote) {
              currentUpvotes++;
              currentDownvotes--;
            } else {
              currentUpvotes--;
              currentDownvotes++;
            }
            transaction.update(voteRef, {'voteType': isUpvote ? 'upvote' : 'downvote'});
          }
        } else {
          if (isUpvote) {
            currentUpvotes++;
          } else {
            currentDownvotes++;
          }
          transaction.set(voteRef, {'userId': user!.uid, 'voteType': isUpvote ? 'upvote' : 'downvote'});
        }

        transaction.update(postRef, {
          'upvotes': currentUpvotes,
          'downvotes': currentDownvotes,
        });
      }
    });

    fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Disaster Posts"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PostScreen()),
              ).then((_) => fetchPosts());
            },
          ),
        ],
      ),
      body: posts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          Post post = posts[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Disaster: ${post.disasterType}', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Location: ${post.location}'),
                  Text('Severity: ${post.severity}'),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.thumb_up, color: Colors.green),
                        onPressed: () => updateVote(post.postId, true),
                      ),
                      Text('${post.upvotes}'),
                      IconButton(
                        icon: Icon(Icons.thumb_down, color: Colors.red),
                        onPressed: () => updateVote(post.postId, false),
                      ),
                      Text('${post.downvotes}'),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text(post.disasterType),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Username: ${post.username}'),
                              Text('Age: ${post.age}'),
                              Text('Description: ${post.description}'),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Text("Show More"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}