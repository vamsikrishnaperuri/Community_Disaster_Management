import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
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

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImageAndSubmitPost() async {
    if (_formKey.currentState!.validate()) {
      String imageUrl = '';

      // Upload image if selected
      if (_selectedImage != null) {
        try {
          final fileName = DateTime.now().millisecondsSinceEpoch.toString();
          final ref = FirebaseStorage.instance
              .ref()
              .child('post_images')
              .child('$fileName.jpg');

          // Upload the image
          UploadTask uploadTask = ref.putFile(_selectedImage!);

          // Wait until upload completes
          TaskSnapshot snapshot = await uploadTask;

          // Get the download URL
          imageUrl = await snapshot.ref.getDownloadURL();

          print("Image uploaded. URL: $imageUrl");
        } catch (e) {
          print('Image upload error: $e');
        }
      }

      // Parse age safely
      int age = 0;
      try {
        age = int.parse(_ageController.text.trim());
      } catch (e) {
        print("Age parsing error: $e");
      }

      // Prepare post data
      final postData = {
        'disasterType': _disasterTypeController.text.trim(),
        'location': _locationController.text.trim(),
        'severity': _severityController.text.trim(),
        'username': _usernameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'age': age,
        'imageUrl': imageUrl,
        'upvotes': 0,
        'downvotes': 0,
        'timestamp': Timestamp.now(),
      };

      // Save to Firestore
      try {
        await FirebaseFirestore.instance.collection('posts').add(postData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Post submitted!')),
        );
      } catch (e) {
        print('Firebase submission error: $e');
      }
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _disasterTypeController,
                decoration: const InputDecoration(labelText: 'Disaster Type'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the disaster type';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the location';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _severityController,
                decoration: const InputDecoration(labelText: 'Severity'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the severity';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  return null;
                },
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Attach Image (optional):'),
                  const SizedBox(height: 8),
                  _selectedImage != null
                      ? Image.file(_selectedImage!, height: 150)
                      : const Text('No image selected'),
                  TextButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text('Select Image from Gallery'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadImageAndSubmitPost,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}