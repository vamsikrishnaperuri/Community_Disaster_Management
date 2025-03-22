import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post_model.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Post>> getPosts() {
    return _firestore.collection('posts').snapshots().map((snapshot) =>
        snapshot.docs
            .map((doc) => Post.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> uploadPost(Post post) async {
    await _firestore.collection('posts').add(post.toMap());
  }

  Future<void> updateVote(String postId, bool isUpvote, String userId) async {
    final doc = _firestore.collection('posts').doc(postId);
    await doc.update({
      isUpvote ? 'upvotes' : 'downvotes': FieldValue.increment(1),
      'votedUsers': FieldValue.arrayUnion([userId])
    });
  }
}
