import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/post_model.dart';
import '../services/post_service.dart';

class PostCard extends StatefulWidget {
  final Post post;
  const PostCard({required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool showMore = false;
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  final PostService postService = PostService();

  void vote(bool isUpvote) async {
    if (widget.post.votedUsers.contains(userId)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("You already voted")));
      return;
    }
    await postService.updateVote(widget.post.id, isUpvote, userId);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Disaster: ${widget.post.disasterName}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Location: ${widget.post.location}"),
            Text("Severity: ${widget.post.severity}"),
            if (showMore) ...[
              Divider(),
              Text("Reported by: ${widget.post.userName}"),
              Text("Age: ${widget.post.age}"),
              Text("Description: ${widget.post.description}"),
            ],
            TextButton(
              child: Text(showMore ? "Show Less" : "Show More"),
              onPressed: () {
                setState(() {
                  showMore = !showMore;
                });
              },
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.thumb_up),
                  onPressed: () => vote(true),
                ),
                Text("${widget.post.upvotes}"),
                SizedBox(width: 20),
                IconButton(
                  icon: Icon(Icons.thumb_down),
                  onPressed: () => vote(false),
                ),
                Text("${widget.post.downvotes}"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
