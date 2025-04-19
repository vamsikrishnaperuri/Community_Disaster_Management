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

  String? _selectedDisasterType;
  String? _selectedSeverity;

  final List<String> disasterTypes = [
    'Cyclone',
    'Hurricane',
    'Earthquake',
    'WildFire',
    'Floods',
    'Volcanic eruption',
    'Drought',
    'Tornado',
    'Fire',
  ];

  final List<String> severityLevels = ['Low', 'Moderate', 'High'];

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
        'username': _usernameController.text,
        'location': _locationController.text,
        'description': _descriptionController.text,
        'age': _ageController.text,
        'disasterType': _selectedDisasterType,
        'severity': _selectedSeverity,
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

      _formKey.currentState!.reset();
      _usernameController.clear();
      _locationController.clear();
      _descriptionController.clear();
      _ageController.clear();
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Disaster Report'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Disaster Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // 🌪️ Disaster Type Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Disaster Type',
                  prefixIcon: Icon(Icons.warning_amber_rounded),
                  border: OutlineInputBorder(),
                ),
                value: _selectedDisasterType,
                items: disasterTypes
                    .map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type),
                ))
                    .toList(),
                onChanged: (val) => setState(() {
                  _selectedDisasterType = val;
                }),
                validator: (val) => val == null ? 'Please select a disaster type' : null,
              ),

              const SizedBox(height: 12),

              // 📍 Location
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Please enter location' : null,
              ),

              const SizedBox(height: 12),

              // 🔥 Severity Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Severity',
                  prefixIcon: Icon(Icons.traffic),
                  border: OutlineInputBorder(),
                ),
                value: _selectedSeverity,
                items: severityLevels
                    .map((level) => DropdownMenuItem(
                  value: level,
                  child: Text(level),
                ))
                    .toList(),
                onChanged: (val) => setState(() {
                  _selectedSeverity = val;
                }),
                validator: (val) => val == null ? 'Please select severity level' : null,
              ),

              const SizedBox(height: 12),

              // 👤 Username
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Your Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Enter your name' : null,
              ),

              const SizedBox(height: 12),

              // 📄 Description
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Please add a description' : null,
              ),

              const SizedBox(height: 12),

              // 🎂 Age
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  prefixIcon: Icon(Icons.cake),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Please enter age' : null,
              ),

              const SizedBox(height: 16),

              // 📸 Image Picker
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Attach Image (optional):', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _selectedImage != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(_selectedImage!, height: 150),
                  )
                      : const Text('No image selected'),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text('Select from Gallery'),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 📤 Submit Button
              ElevatedButton.icon(
                onPressed: _uploadImageAndSubmitPost,
                icon: const Icon(Icons.cloud_upload),
                label: const Text('Submit Post',style: TextStyle(
                  color: Colors.white,
                ),),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                  backgroundColor: Colors.deepPurple,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}