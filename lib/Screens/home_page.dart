import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import '../models/post_model.dart';
import 'post_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Post> posts = [];
  List<Post> filteredPosts = [];
  final user = FirebaseAuth.instance.currentUser;
  bool isNearbyFilterEnabled = false;
  Position? currentPosition;

  @override
  void initState() {
    super.initState();
    fetchPosts();
    _determinePosition();
  }

  Future<void> fetchPosts() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('posts').get();
      setState(() {
        posts = snapshot.docs.map((doc) {
          return Post.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();
        filteredPosts = posts;
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

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentPosition = position;
    });
  }

  Future<void> _filterNearbyPosts() async {
    if (currentPosition != null) {
      List<Post> nearbyPosts = [];
      for (Post post in posts) {
        try {
          List<geocoding.Location> locations = await geocoding.locationFromAddress(post.location);
          if (locations.isNotEmpty) {
            double distanceInMeters = Geolocator.distanceBetween(
              currentPosition!.latitude,
              currentPosition!.longitude,
              locations.first.latitude,
              locations.first.longitude,
            );
            if (distanceInMeters <= 10000) {
              nearbyPosts.add(post); // Filter posts within 10 km
            }
          }
        } catch (e) {
          print('Error getting location for ${post.location}: $e');
        }
      }
      setState(() {
        filteredPosts = nearbyPosts;
      });
    }
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
          IconButton(
            icon: Icon(isNearbyFilterEnabled ? Icons.filter_list_off : Icons.filter_list),
            onPressed: () {
              setState(() {
                isNearbyFilterEnabled = !isNearbyFilterEnabled;
                if (isNearbyFilterEnabled) {
                  _filterNearbyPosts();
                } else {
                  filteredPosts = posts;
                }
              });
            },
          ),
        ],
      ),
      body: filteredPosts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: filteredPosts.length,
        itemBuilder: (context, index) {
          Post post = filteredPosts[index];
          return PostCard(
            post: post,
            onVote: (isUpvote) => updateVote(post.postId, isUpvote),
          );
        },
      ),
    );
  }
}

class PostCard extends StatefulWidget {
  final Post post;
  final Function(bool) onVote;

  const PostCard({required this.post, required this.onVote});

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _showDetails = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(Icons.thumb_up, color: Colors.green),
                          onPressed: () => widget.onVote(true),
                        ),
                        Text('Upvote'),
                      ],
                    ),
                    Text('${widget.post.upvotes}'),
                    SizedBox(width: 10), // spacing
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(Icons.thumb_down, color: Colors.red),
                          onPressed: () => widget.onVote(false),
                        ),
                        Text('Downvote'),
                      ],
                    ),
                    Text('${widget.post.downvotes}'),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _showDetails = !_showDetails;
                    });
                  },
                  child: Text("Show More"),
                ),
              ],
            ),
            AnimatedOpacity(
              opacity: _showDetails ? 1.0 : 0.0,
              duration: Duration(milliseconds: 300),
              child: _showDetails
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Username: ${widget.post.username}'),
                  Text('Age: ${widget.post.age}'),
                  Text('Description: ${widget.post.description}'),
                ],
              )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}