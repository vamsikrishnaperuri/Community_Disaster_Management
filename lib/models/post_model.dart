class Post {
  String id;
  String userName;
  String location;
  int age;
  String disasterName;
  String severity;
  String description;
  int upvotes;
  int downvotes;
  List<String> votedUsers;

  Post({
    required this.id,
    required this.userName,
    required this.location,
    required this.age,
    required this.disasterName,
    required this.severity,
    required this.description,
    required this.upvotes,
    required this.downvotes,
    required this.votedUsers,
  });

  factory Post.fromMap(Map<String, dynamic> map, String id) {
    return Post(
      id: id,
      userName: map['userName'],
      location: map['location'],
      age: map['age'],
      disasterName: map['disasterName'],
      severity: map['severity'],
      description: map['description'],
      upvotes: map['upvotes'],
      downvotes: map['downvotes'],
      votedUsers: List<String>.from(map['votedUsers'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'location': location,
      'age': age,
      'disasterName': disasterName,
      'severity': severity,
      'description': description,
      'upvotes': upvotes,
      'downvotes': downvotes,
      'votedUsers': votedUsers,
    };
  }
}
