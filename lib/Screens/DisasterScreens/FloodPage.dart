import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:url_launcher/url_launcher.dart';

class FloodPage extends StatefulWidget {
  const FloodPage({super.key});

  @override
  State<FloodPage> createState() => _EarthquakePageState();
}

class _EarthquakePageState extends State<FloodPage> {
  double intensity = 0.5; // Initial intensity (0.0 to 1.0)
  Color ringColor = Colors.blue; // Initial ring color
  String selectedState = 'Andhra Pradesh'; // Initial state

  final Map<String, double> stateIntensities = {

    'Punjab' :  0.37,
    'Uttar Pradesh': 0.74,
    'Bihar': 0.43,
    'Rajasthan': 0.33,
    'Assam': 0.32,
    'Odisha': 0.14,
    'West Bengal': 0.27,
    'Haryana': 0.24,
    'Andhra Pradesh': 0.14,
    'Gujarat': 0.14,
    'Kerala': 0.09,
    'Karnataka': 0.13,
    'Madhya Pradesh': 0.2,
    'Telangana': 0.01,
    'Tamil Nadu':  0.01,
    'Maharashtra':  0.01,
    'Arunachal Pradesh': 0.01,
    'Meghalaya':  0.01,
    'Manipur':  0.01,
    'Himachal Pradesh':  0.01,
    'Jammu & Kashmir':  0.01,
    'Uttarkhand':  0.01,
    'Sikkim':   0.01,
  };

  final Map<String, Color> stateColors = {  // New: State-specific colors

    'Punjab' :  Colors.orange,
    'Uttar Pradesh': Colors.red,
    'Bihar': Colors.red,
    'Rajasthan': Colors.orange,
    'Assam': Colors.orange,
    'Odisha': Colors.limeAccent,
    'West Bengal': Colors.yellowAccent,
    'Haryana': Colors.yellowAccent,
    'Andhra Pradesh': Colors.limeAccent,
    'Gujarat': Colors.limeAccent,
    'Kerala':Colors.lightGreenAccent,
    'Karnataka': Colors.limeAccent,
    'Madhya Pradesh': Colors.yellow,
    'Telangana': Colors.green,
    'Tamil Nadu': Colors.green,
    'Maharashtra': Colors.green,
    'Arunachal Pradesh': Colors.green,
    'Meghalaya': Colors.green,
    'Manipur': Colors.green,
    'Himachal Pradesh': Colors.green,
    'Jammu & Kashmir': Colors.green,
    'Uttarkhand': Colors.green,
    'Sikkim':  Colors.green,
  };

  @override
  void initState() {
    super.initState();
    _updateIntensityAndColor(); // Initialize on startup
  }

  void _updateIntensityAndColor() {
    setState(() {
      intensity = stateIntensities[selectedState] ?? 0.5; // Default 0.5 if not found
      // Example color mapping – customize as needed
      ringColor = stateColors[selectedState] ?? Colors.grey;
    });
  }

  void _showStatePicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        String filter = ''; // For search filtering

        return StatefulBuilder( // Use StatefulBuilder for filtering
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.5, // Adjust height as needed
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(hintText: 'Search State'),
                    onChanged: (value) {
                      setState(() {
                        filter = value.toLowerCase();
                      });
                    },
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: stateIntensities.keys.length,
                      itemBuilder: (context, index) {
                        final state = stateIntensities.keys.toList()[index];
                        if (state.toLowerCase().contains(filter)) { // Apply filter
                          return ListTile(
                            title: Text(state),
                            onTap: () {
                              setState(() {
                                selectedState = state;
                                _updateIntensityAndColor();
                              });
                              Navigator.pop(context); // Close the bottom sheet
                            },
                          );
                        } else {
                          return Container(); // Return empty container for filtered-out items
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Floods Prone Status')), // Corrected title
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Numorphic Ring
            AnimatedContainer(
              duration: const Duration(milliseconds: 300), // Smooth animation
              curve: Curves.easeInOut,
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).scaffoldBackgroundColor, // Background color
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    offset: const Offset(5, 5),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.7),
                    offset: const Offset(-5, -5),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Center(
                    child: SizedBox( // Outer ring (CircularProgressIndicator)
                      width: 180,
                      height: 180,
                      child: TweenAnimationBuilder<double>( // For color animation
                        tween: Tween<double>(begin: 0, end: intensity),
                        duration: const Duration(milliseconds: 500), // Adjust duration
                        builder: (context, value, child) {
                          return CircularProgressIndicator(
                            value: value,
                            color: Color.lerp(Colors.green, ringColor, value), // Animated color
                            strokeWidth: 15,
                            backgroundColor: Colors.transparent,
                          );
                        },
                      ),
                    ),
                  ),
                  Center(  // Inner transparent circle with INNER shadow
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).scaffoldBackgroundColor, // Background color
                        boxShadow: [
                          BoxShadow( // Inner shadow
                            color: Colors.grey.withOpacity(0.3), // Slightly darker for inner shadow
                            offset: const Offset(2, 2), // Adjust offset as needed
                            blurRadius: 5,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center( // Intensity display
                    child: Text(
                      (intensity * 10).toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54, // Or any color that contrasts well
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Dropdown Button
            // DropdownButton<String>(
            //   value: selectedState,
            //   items: stateIntensities.keys.map((state) {
            //     return DropdownMenuItem<String>(
            //       value: state,
            //       child: Text(state),
            //     );
            //   }).toList(),
            //   onChanged: (newValue) {
            //     if (newValue != null) {
            //       setState(() {
            //         selectedState = newValue;
            //         _updateIntensityAndColor();
            //       });
            //     }
            //   },
            // ),
            const Center(
              child: Text(
                'Select State',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton( // Or any button style you prefer
              onPressed: _showStatePicker,
              child: Text(selectedState),
            ),
            const SizedBox(height: 20), // Add spacing between buttons
            ElevatedButton(
              onPressed: () async {
                final Uri url = Uri.parse('https://www.swechaap.org/helpline/dashboard/');
                await launchUrl(url); // Try without canLaunchUrl
              },
              child: const Text('Floods Dashboard'),
            ),
          ],

        ),
      ),
    );
  }
}
