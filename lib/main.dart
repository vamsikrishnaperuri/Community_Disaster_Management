import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:w_a_p/Screens/DisasterInfoScreen.dart';
import 'Screens/e_numbers_page.dart';
import 'Screens/feedback_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Geolocator.checkPermission();
  await Geolocator.requestPermission();

  try {
    if (Platform.isAndroid) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSyBa5VHQli1HH8DlWdKkaXFlvnoZwukR_Do',
          appId: '1:53547670839:android:99347bc9a1265a1d16ceb2',
          messagingSenderId: '53547670839',
          projectId: 'disaster-5e1e5',
          storageBucket: 'disaster-5e1e5.firebasestorage.app',
        ),
      );
    } else {
      await Firebase.initializeApp();
    }

    await FirebaseAuth.instance.signInAnonymously();
  } catch(e) {
    print('Error initializing Firebase: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Bar Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    ENumbersPage(),
    DisasterInfoScreen(),
    FeedbackPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.hub_outlined),
            label: 'Hub',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feedback_outlined),
            label: 'Feedback',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}
