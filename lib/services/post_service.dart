import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post_model.dart';


class PostServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Post>> fetchPosts() async {
    QuerySnapshot snapshot = await _firestore.collection('posts').get();
    return snapshot.docs.map((doc) {
      return Post.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  Future<void> updateVote(String postId, bool isUpvote) async {
    DocumentReference postRef = _firestore.collection('posts').doc(postId);

    await _firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(postRef);
      if (snapshot.exists) {
        int currentUpvotes = snapshot['upvotes'] ?? 0;
        int currentDownvotes = snapshot['downvotes'] ?? 0;

        transaction.update(postRef, {
          'upvotes': isUpvote ? currentUpvotes + 1 : currentUpvotes,
          'downvotes': isUpvote ? currentDownvotes : currentDownvotes + 1,
        });
      }
    });
  }
}
