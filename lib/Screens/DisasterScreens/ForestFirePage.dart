import 'package:flutter/material.dart';

class ForestFirePage extends StatelessWidget {
  const ForestFirePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forest Fires')),
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
                    'lib/assets/forestfiregraph.png', // Replace with actual image URL
                    fit: BoxFit.cover,
                    height: 200,
                    width: 400,
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
  StateIntensity(name: 'Mizoram', intensity: 0.7, color: Colors.red),
  StateIntensity(name: 'Manipur', intensity: 0.42, color: Colors.orange),
  StateIntensity(name: 'Assam', intensity: 0.41, color: Colors.orange),
  StateIntensity(name: 'Andhra Pradesh', intensity: 0.45, color: Colors.orange),
  StateIntensity(name: 'Odisha', intensity: 0.31, color: Colors.yellow),
  StateIntensity(name: 'Madhya Pradesh', intensity: 0.31, color: Colors.yellow),
  StateIntensity(name: 'Meghalaya', intensity: 0.29, color: Colors.greenAccent),
  StateIntensity(name: 'Maharashtra', intensity: 0.28, color: Colors.yellow),
  StateIntensity(name: 'Nagaland', intensity: 0.29, color: Colors.yellow),
  StateIntensity(name: 'Chatisgarh', intensity: 0.29, color: Colors.yellow),
];