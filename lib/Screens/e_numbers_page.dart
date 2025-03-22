import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'emergency_numbers.dart';

class ENumbersPage extends StatefulWidget {
  const ENumbersPage({super.key});

  @override
  State<ENumbersPage> createState() => _ENumbersPageState();
}

class _ENumbersPageState extends State<ENumbersPage> {
  List<EmergencyNumber> filteredNumbers = emergencyNumbers;
  String searchText = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Color(0xFFE6E6FA),
        body: Padding( // Scaffold still needed for safe area, etc.
          padding: const EdgeInsets.only(
            top: 16.0,
            left: 16.0,
            right: 16.0,
            bottom: 16.0,
          ),
          child: Column( // Use a Column to place search bar and list
            children: [
              Padding( // Search bar padding
                padding: const EdgeInsets.only(bottom: 8.0), // Space below search bar
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchText = value;
                      _filterNumbers();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    prefixIconConstraints: const BoxConstraints(minWidth: 40),
                    suffixIcon: searchText.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        setState(() {
                          searchText = "";
                          _filterNumbers();
                        });
                      },
                    )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(200.0),
                      borderSide: const BorderSide(color: Colors.black, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(200.0),
                      borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 16.0),
                  ),
                ),
              ),
              Expanded( // Expand the list to fill remaining space
                child: ListView.builder(
                  itemCount: filteredNumbers.length,
                  itemBuilder: (context, index) {
                    final emergencyNumber = filteredNumbers[index];
                    return Card(
                      color: Color(0xFFE6E6FA), // Corrected hex code for Flutter,
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        title: Text(emergencyNumber.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 18)),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(emergencyNumber.description,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey)),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.call, color: Colors.red),
                          onPressed: () {
                            _makePhoneCall(emergencyNumber.phoneNumber, context);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _filterNumbers() {
    setState(() {
      filteredNumbers = emergencyNumbers
          .where((number) =>
      number.name.toLowerCase().contains(searchText.toLowerCase()) ||
          number.description.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  void _makePhoneCall(String phoneNumber, BuildContext context) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not make call.')),
      );
    }
  }
}