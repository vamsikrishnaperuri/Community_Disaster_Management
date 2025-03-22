import 'package:flutter/material.dart';

import 'DisasterScreens/CyclonePage.dart';
import 'DisasterScreens/EarthquakePage.dart';
import 'DisasterScreens/FloodPage.dart';
import 'DisasterScreens/ForestFirePage.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {

  final Map<String, Widget> disasterPages = {
    'Cyclone': const CyclonePage(),
    // 'Hurricanes': const HurricanePage(),
    'Earthquakes': const EarthquakePage(),
    'Floods': const FloodPage(),
    'Forest Fires': const ForestFirePage(),
    // 'Tornadoes': const TornadoPage(),
  };


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Disaster Types')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 30,
            childAspectRatio: 1.2,
          ),
          itemCount: disasterPages.keys.length,
          itemBuilder: (context, index) {
            String title = disasterPages.keys.elementAt(index);
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => disasterPages[title]!),
                );
              },
              child: _buildDisasterCard(title),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDisasterCard(String title) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft, // Start point of the gradient
          end: Alignment.bottomRight, // End point of the gradient
          colors: [
            Colors.blueAccent, // Start color
            Colors.blue,  // Middle color (optional)
            Colors.lightBlueAccent, // End color
          ],
        ),
        // color: Colors.white70,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          const BoxShadow(
            color: Colors.white,
            offset: Offset(-5, -5),
            blurRadius: 10,
          ),
          BoxShadow(
            color: Colors.grey.shade500,
            offset: Offset(5, 5),
            blurRadius: 10,
          ),
        ],
      ),
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          // gradient: const LinearGradient(
          //   begin: Alignment.topLeft, // Start point of the gradient
          //   end: Alignment.bottomRight, // End point of the gradient
          //   colors: [
          //     Colors.blueAccent, // Start color
          //     Colors.blue,  // Middle color (optional)
          //     Colors.lightBlueAccent, // End color
          //   ],
          // ),
          color: Colors.white70,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              offset: Offset(2, 2), // Inner shadow at bottom-right
              blurRadius: 6,
              spreadRadius: 2,
            ),
            const BoxShadow(
              color: Colors.white,
              offset: Offset(-2, -2), // Inner shadow at top-left
              blurRadius: 6,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class DisasterDetailPage extends StatelessWidget {
  final String title;

  const DisasterDetailPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text(
          'Details about $title',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

const List<String> disasterTypes = [
  'Cyclone',
  'Hurricanes',
  'Earthquakes',
  'Floods',
  'Forest Fires',
  'Tornadoes',
];
