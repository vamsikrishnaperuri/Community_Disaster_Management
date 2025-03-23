class Post {
  final String disasterType;
  final String location;
  final String severity;
  final String username;
  final String description;
  final int age;
  final int upvotes;
  final int downvotes;
  final String postId;

  Post({
    required this.disasterType,
    required this.location,
    required this.severity,
    required this.username,
    required this.description,
    required this.age,
    required this.upvotes,
    required this.downvotes,
    required this.postId,
  });

  factory Post.fromFirestore(Map<String, dynamic> data, String id) {
    return Post(
      disasterType: data['disasterType'] ?? '',
      location: data['location'] ?? '',
      severity: data['severity'] ?? '',
      username: data['username'] ?? '',
      description: data['description'] ?? '',
      age: data['age'] ?? 0,
      upvotes: data['upvotes'] ?? 0,
      downvotes: data['downvotes'] ?? 0,
      postId: id,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'disasterType': disasterType,
      'location': location,
      'severity': severity,
      'username': username,
      'description': description,
      'age': age,
      'upvotes': upvotes,
      'downvotes': downvotes,
    };
  }
}