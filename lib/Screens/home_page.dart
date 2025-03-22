import 'package:flutter/material.dart';
import '../services/post_service.dart';
import '../widgets/post_card.dart';
import '../models/post_model.dart';

class HomePage extends StatelessWidget {
  final PostService postService = PostService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Disaster Posts")),
      body: StreamBuilder<List<Post>>(
        stream: postService.getPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.isEmpty)
            return Center(child: Text("No posts yet"));

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return PostCard(post: snapshot.data![index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add UploadPost screen
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
