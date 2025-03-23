import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../services/post_service.dart';


class PostCard extends StatefulWidget {
  final Post post;
  final VoidCallback refreshPosts; // To re-fetch after voting

  PostCard({required this.post, required this.refreshPosts});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool showMore = false;
  bool hasVoted = false;

  final PostServices _postServices = PostServices();

  void vote(bool isUpvote) async {
    if (hasVoted) return; // Restrict multiple votes

    await _postServices.updateVote(widget.post.postId, isUpvote);
    widget.refreshPosts();
    setState(() {
      hasVoted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Disaster: ${widget.post.disasterType}', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Location: ${widget.post.location}'),
            Text('Severity: ${widget.post.severity}'),
            SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.thumb_up, color: Colors.green),
                  onPressed: () => vote(true),
                ),
                Text('${widget.post.upvotes}'),
                IconButton(
                  icon: Icon(Icons.thumb_down, color: Colors.red),
                  onPressed: () => vote(false),
                ),
                Text('${widget.post.downvotes}'),
              ],
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  showMore = !showMore;
                });
              },
              child: Text(showMore ? "Show Less" : "Show More"),
            ),
            if (showMore) ...[
              Text('Username: ${widget.post.username}'),
              Text('Age: ${widget.post.age}'),
              Text('Description: ${widget.post.description}'),
            ]
          ],
        ),
      ),
    );
  }
}
