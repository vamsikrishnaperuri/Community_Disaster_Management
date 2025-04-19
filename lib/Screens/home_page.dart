import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:http/http.dart';
import '../models/post_model.dart';
import 'package:intl/intl.dart';
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
      // print('Error fetching posts: $e');
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
        title: const Text("Disaster Posts"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
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
          ? const Center(child: CircularProgressIndicator())
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
    return Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: getSeverityColor(widget.post.severity),
          width: 2,
        ),
      ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Circular image
                  ClipOval(
                    child: (widget.post.imageUrl != null &&
                        widget.post.imageUrl!.isNotEmpty &&
                        Uri.tryParse(widget.post.imageUrl!)?.hasAbsolutePath == true)
                        ? Image.network(
                      widget.post.imageUrl!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'lib/assets/defaultimgcam.png',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                        : Image.asset(
                      'lib/assets/defaultimgcam.png',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Main info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.post.disasterType.toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              DateFormat('yyyy-MM-dd').format(widget.post.timestamp.toDate()), // Assuming 'timestamp' is a Firestore Timestamp
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF1B3C36),
                              ),
                            ),
                          ],
                        ),


                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                "Location: ${widget.post.location}",
                                style: const TextStyle(fontSize: 13, color: Colors.black),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.warning, size: 14, color: Colors.orange),
                            const SizedBox(width: 4),
                              const Text(
                              "Severity: ",
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              widget.post.severity,
                              style: TextStyle(
                                fontSize: 13,
                                color: widget.post.severity.toLowerCase() == 'high'
                                    ? Colors.red
                                    : widget.post.severity.toLowerCase() == 'moderate'
                                    ? Colors.orange
                                    : Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Voting and toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.thumb_up, color: Colors.green),
                            onPressed: () => widget.onVote(true),
                          ),
                          Text('${widget.post.upvotes}'),
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.thumb_down, color: Colors.red),
                            onPressed: () => widget.onVote(false),
                          ),
                          Text('${widget.post.downvotes}'),
                        ],
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _showDetails = !_showDetails;
                      });
                    },
                    child: Text(
                      _showDetails ? "Hide Details" : "Show More",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),

              // Expandable details
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("👤 Username: ${widget.post.username}"),
                      Text("🎂 Age: ${widget.post.age}"),
                      Text("📝 Description: ${widget.post.description}"),
                    ],
                  ),
                ),
                crossFadeState:
                _showDetails ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              ),
            ],
          ),
        ),
      );
  }
}

Color getSeverityColor(String severity) {
  switch (severity.toLowerCase()) {
    case 'high':
      return Colors.red;
    case 'medium':
      return Colors.orange;
    case 'moderate':
      return Colors.orange;
    case 'low':
      return Colors.green;
    default:
      return Colors.grey;
  }
}
