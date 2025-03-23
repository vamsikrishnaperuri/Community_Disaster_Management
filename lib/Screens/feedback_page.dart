import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white10,
        title: Text(
          "Chatbot",
          style: GoogleFonts.salsa(
            textStyle: TextStyle(
              color: Colors.amber[800],
              fontSize: 30,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'available soon..',
          style: GoogleFonts.salsa(
            textStyle: TextStyle(
              color: Colors.amber[800],
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }
}