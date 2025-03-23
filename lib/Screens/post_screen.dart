import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/post_model.dart';

class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _disasterTypeController = TextEditingController();
  final _locationController = TextEditingController();
  final _severityController = TextEditingController();
  final _usernameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ageController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    _disasterTypeController.dispose();
    _locationController.dispose();
    _severityController.dispose();
    _usernameController.dispose();
    _descriptionController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _submitPost() async {
    if (_formKey.currentState!.validate()) {
      final newPost = Post(
        disasterType: _disasterTypeController.text,
        location: _locationController.text,
        severity: _severityController.text,
        username: _usernameController.text,
        description: _descriptionController.text,
        age: int.parse(_ageController.text),
        upvotes: 0,
        downvotes: 0,
        postId: '',
      );

      await FirebaseFirestore.instance.collection('posts').add(newPost.toFirestore());
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _disasterTypeController,
                decoration: InputDecoration(labelText: 'Disaster Type'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the disaster type';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the location';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _severityController,
                decoration: InputDecoration(labelText: 'Severity'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the severity';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitPost,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}