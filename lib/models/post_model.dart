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
  final String imageUrl;

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
    required this.imageUrl
  });

  factory Post.fromFirestore(Map<String, dynamic> data, String id) {
    return Post(
      disasterType: data['disasterType'] ?? '',
      location: data['location'] ?? '',
      severity: data['severity'] ?? '',
      username: data['username'] ?? '',
      description: data['description'] ?? '',
      age: data['age'] is int ? data['age'] : int.tryParse(data['age'].toString()) ?? 0,
      upvotes: data['upvotes'] is int ? data['upvotes'] : int.tryParse(data['upvotes'].toString()) ?? 0,
      downvotes: data['downvotes'] is int ? data['downvotes'] : int.tryParse(data['downvotes'].toString()) ?? 0,
      postId: id,
      imageUrl: data['imageUrl'] ?? '',
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
      'imageUrl': imageUrl,
    };
  }
}