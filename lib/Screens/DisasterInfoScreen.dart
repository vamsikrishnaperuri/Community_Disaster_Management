import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DisasterInfoScreen extends StatefulWidget {
  const DisasterInfoScreen({Key? key}) : super(key: key);

  @override
  State<DisasterInfoScreen> createState() => _DisasterInfoScreenState();
}

class _DisasterInfoScreenState extends State<DisasterInfoScreen> {
  Map<String, bool> kitChecklist = {
    'First Aid Kit': false,
    'Water Bottles': false,
    'Flashlight & Batteries': false,
    'Non-perishable Food': false,
    'Important Documents': false,
    'Whistle': false,
  };

  @override
  void initState() {
    super.initState();
    _loadChecklist();
  }

  // ✅ Load checklist from SharedPreferences
  Future<void> _loadChecklist() async {
    final prefs = await SharedPreferences.getInstance();
    final storedChecklist = prefs.getString('kitChecklist');
    if (storedChecklist != null) {
      final Map<String, dynamic> decoded = jsonDecode(storedChecklist);
      setState(() {
        kitChecklist = decoded.map((key, value) => MapEntry(key, value as bool));
      });
    }
  }

  // ✅ Save checklist to SharedPreferences
  Future<void> _saveChecklist() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(kitChecklist);
    await prefs.setString('kitChecklist', encoded);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Disaster Awareness Hub",style: TextStyle(
          color: Colors.deepOrange,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),),
        // backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "🧠 Learn How to Stay Safe",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // 🔽 Safety Tips
            _buildSafetyTile(
              title: "🌍 Earthquake Safety",
              tips: [
                "Drop, Cover, and Hold On during shaking.",
                "Stay away from windows.",
                "After shaking stops, evacuate if necessary.",
              ],
            ),
            _buildSafetyTile(
              title: "💧 Flood Safety",
              tips: [
                "Move to higher ground immediately.",
                "Avoid walking or driving through flood waters.",
                "Unplug electrical appliances.",
              ],
            ),
            _buildSafetyTile(
              title: "🔥 Fire Safety",
              tips: [
                "Stop, Drop, and Roll if clothes catch fire.",
                "Use stairs instead of elevators.",
                "Know at least two exit routes from your home.",
              ],
            ),

            const SizedBox(height: 24),

            // ✅ Emergency Kit Checklist
            const Text(
              "🎒 Emergency Kit Checklist",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            ...kitChecklist.keys.map((item) => CheckboxListTile(
              title: Text(item),
              value: kitChecklist[item],
              onChanged: (bool? value) {
                setState(() {
                  kitChecklist[item] = value ?? false;
                });
                _saveChecklist(); // Save on change
              },
            )),

            const SizedBox(height: 24),

            // Center(
            //   child: ElevatedButton.icon(
            //     onPressed: () {
            //       // Navigate to quiz screen later
            //     },
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.deepOrange,
            //       padding: const EdgeInsets.symmetric(
            //           horizontal: 20, vertical: 12),
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(12)),
            //     ),
            //     icon: const Icon(Icons.quiz),
            //     label: const Text("Take Safety Awareness Quiz"),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildSafetyTile({required String title, required List<String> tips}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        children: tips
            .map((tip) => ListTile(
          leading: const Icon(Icons.check_circle_outline,
              color: Colors.green),
          title: Text(tip),
        ))
            .toList(),
      ),
    );
  }
}
