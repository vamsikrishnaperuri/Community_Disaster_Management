import 'package:flutter/material.dart';

class CyclonePage extends StatelessWidget {
  const CyclonePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cyclone')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: Colors.white, offset: Offset(-4, -4), blurRadius: 8),
                    BoxShadow(color: Colors.grey.shade500, offset: Offset(4, 4), blurRadius: 8),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'lib/assets/cyclonemap.png', // Replace with actual image URL
                    fit: BoxFit.cover,
                    height: 425,
                    width: double.infinity,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Column(
                children: states.map((state) => _buildStateRow(state)).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStateRow(StateIntensity state) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            state.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          NeumorphicBar(width: 150, height: 20, value: state.intensity, color: state.color),
        ],
      ),
    );
  }
}

class NeumorphicBar extends StatelessWidget {
  const NeumorphicBar({
    Key? key,
    required this.width,
    required this.height,
    required this.value,
    this.color,
  }) : super(key: key);

  final double width;
  final double height;
  final double value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.grey[300],
        boxShadow: [
          BoxShadow(color: Colors.white, offset: Offset(-3, -3), blurRadius: 5),
          BoxShadow(color: Colors.grey.shade500, offset: Offset(3, 3), blurRadius: 5),
        ],
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: width * value,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: color ?? Colors.blue,
          ),
        ),
      ),
    );
  }
}

class StateIntensity {
  final String name;
  final double intensity;
  final Color color;

  StateIntensity({required this.name, required this.intensity, required this.color});
}

final List<StateIntensity> states = [
  StateIntensity(name: 'Odisha', intensity: 0.7, color: Colors.red),
  StateIntensity(name: 'West Bengal', intensity: 0.8, color: Colors.red),
  StateIntensity(name: 'Gujarat', intensity: 0.7, color: Colors.orange),
  StateIntensity(name: 'Andhra Pradesh', intensity: 0.7, color: Colors.orange),
  StateIntensity(name: 'Tamil Nadu', intensity: 0.6, color: Colors.orange),
  StateIntensity(name: 'Kerala', intensity: 0.3, color: Colors.greenAccent),
  StateIntensity(name: 'Goa', intensity: 0.7, color: Colors.orange),
  StateIntensity(name: 'Maharashtra', intensity: 0.6, color: Colors.yellow),
  StateIntensity(name: 'Karnataka', intensity: 0.5, color: Colors.yellow),
];