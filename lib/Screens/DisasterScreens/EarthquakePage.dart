import 'package:flutter/material.dart';
import 'dart:math' as math; // Import for generating random values

class EarthquakePage extends StatefulWidget {
  const EarthquakePage({super.key});

  @override
  State<EarthquakePage> createState() => _EarthquakePageState();
}

class _EarthquakePageState extends State<EarthquakePage> {
  double intensity = 0.5; // Initial intensity (0.0 to 1.0)
  Color ringColor = Colors.blue; // Initial ring color
  String selectedState = 'Andhra Pradesh'; // Initial state

  final Map<String, double> stateIntensities = {

    'Andhra Pradesh': 0.2,
    'Telangana': 0.2,
    'Karnataka': 0.2,
    'Tamil Nadu': 0.2,
    'Kerala': 0.3,
    'Maharashtra': 0.35,
    'Odisha': 0.9,
    'West Bengal': 0.4,
    'Madhya Pradesh': 0.4,
    'Gujarat': 0.6,
    'Rajasthan': 0.3,
    'Uttar Pradesh': 0.4,
    'Arunachal Pradesh': 0.8,
    'Assam': 0.75,
    'Meghalaya': 0.75,
    'Manipur': 0.8,
    'Himachal Pradesh': 0.75,
    'Jammu & Kashmir': 0.7,
    'Uttarkhand': 0.75,
    'Punjab' :  0.5,
    'New Delhi' :  0.5,
    'Bihar':  0.6,
    'Sikkim':  0.5,

  };

  final Map<String, Color> stateColors = {  // New: State-specific colors
    'Andhra Pradesh': Colors.green,
    'Telangana': Colors.green,
    'Karnataka': Colors.green,
    'Tamil Nadu': Colors.green,
    'Kerala': Colors.lightGreenAccent,
    'Maharashtra': Colors.lightGreenAccent,
    'Odisha': Colors.red,
    'West Bengal': Colors.limeAccent,
    'Madhya Pradesh': Colors.limeAccent,
    'Gujarat': Colors.yellow,
    'Rajasthan': Colors.lightGreenAccent,
    'Uttar Pradesh': Colors.limeAccent,
    'Arunachal Pradesh': Colors.redAccent,
    'Assam': Colors.orange,
    'Meghalaya': Colors.orange,
    'Manipur': Colors.redAccent,
    'Himachal Pradesh': Colors.orange,
    'Jammu & Kashmir': Colors.orangeAccent,
    'Uttarkhand': Colors.orange,
    'Punjab' :  Colors.yellowAccent,
    'New Delhi' :  Colors.yellowAccent,
    'Bihar':  Colors.yellow,
    'Sikkim':  Colors.yellowAccent,
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
      appBar: AppBar(title: const Text('Earthquake Prone Status')), // Corrected title
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
          ],
        ),
      ),
    );
  }
}