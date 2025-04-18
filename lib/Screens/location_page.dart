import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  String alertMessage = 'Press "Get Report" to fetch alerts for your area.';
  String safeAreasMessage = '';


  Future<void> _getReport() async {
    try {
      // Check location permissions
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          alertMessage = 'Location services are disabled.';
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            alertMessage = 'Location permissions are denied.';
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          alertMessage = 'Location permissions are permanently denied.';
        });
        return;
      }

      // Get current location
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Prepare data to send
      Map<String, dynamic> data = {
        'lat': position.latitude,
        'lng': position.longitude,
        'api_key': 'ker234kj4kj34j234',
      };

      // Send POST request
      final response = await http.post(
        Uri.parse('http://192.168.16.184:8000/getData'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),


      );

      // Handle response
      if (response.statusCode == 200) {
        try {
          // First decode
          String jsonString = json.decode(response.body);

          // Second decode
          Map<String, dynamic> responseData = json.decode(jsonString);

          if (responseData['number_of_alerts'] > 0) {
            setState(() {
              alertMessage = responseData['alerts'].join('\n');

              // Add dummy safe area suggestions
              safeAreasMessage = '\n\n🟢 Safe Areas to Shift:\n';
              safeAreasMessage += '1. Green Valley Park\n   Coordinates: 17.385044, 78.486671\n   City: Hyderabad\n\n';
              safeAreasMessage += '2. Blue Hills Shelter\n   Coordinates: 17.4504, 78.3806\n   City: Hyderabad';
            });
          } else {
            setState(() {
              alertMessage = '✅ All safe in your area.';
              safeAreasMessage = ''; // No safe areas needed
            });
          }
        } catch (e) {
          setState(() {
            alertMessage = 'Error parsing response: $e';
            safeAreasMessage = '';
          });
        }
      } else {
        setState(() {
          alertMessage = 'Failed to fetch alerts.';
          safeAreasMessage = '';
        });
      }
    } catch (e) {
      setState(() {
        alertMessage = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Disaster Types')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Alerts Card
            Card(
              margin: EdgeInsets.all(12),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text(
                      '⚠️ Alerts',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(alertMessage),
                    if (safeAreasMessage.isNotEmpty) ...[
                      SizedBox(height: 16),
                      Text(
                        safeAreasMessage,
                        style: TextStyle(color: Colors.green[700]),
                      ),
                    ],
                  ],
                ),
              ),
            ),


            const SizedBox(height: 20),

            // Get Report Button
            ElevatedButton(
              onPressed: _getReport,
              child: const Text('Get Report'),
            ),
            const SizedBox(height: 20),

            // Disaster Cards

          ],
        ),
      ),
    );
  }






}

