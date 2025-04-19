import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  double rating = 0;
  String summary = '';

  void _submitFeedback() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection('feedbacks').add({
        'name': name,
        'rating': rating,
        'summary': summary,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Feedback submitted!')),
      );

      // Clear the form
      _formKey.currentState!.reset();
      setState(() {
        rating = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feedback Form')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Name
              Container(
                height: 200,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('lib/assets/feedback.png'),
                    fit: BoxFit.cover,
                    // ),
                  ),
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.orange, // highlight color on focus
                      width: 2,
                    ),
                  ),
                  prefixIcon: Icon(Icons.person, color: Colors.orange),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'Enter your name' : null,
                onChanged: (value) => name = value,
              ),


              const SizedBox(height: 20),

              // Star Rating
              const Text("Rate us:"),
              RatingBar.builder(
                initialRating: rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (r) => rating = r,
              ),

              const SizedBox(height: 20),

              // Summary
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Summary',
                  labelStyle: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  alignLabelWithHint: true,
                  hintText: "Write your feedback here...",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.deepOrange,
                      width: 2,
                    ),
                  ),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 60), // adjust for multiline
                    child: Icon(Icons.feedback_outlined, color: Colors.deepOrange),
                  ),
                ),
                maxLines: 4,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please write your feedback'
                    : null,
                onChanged: (value) => summary = value,
              ),


              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _submitFeedback,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
