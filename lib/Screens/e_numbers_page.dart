import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'DisasterScreens/CyclonePage.dart';
import 'DisasterScreens/EarthquakePage.dart';
import 'DisasterScreens/FloodPage.dart';
import 'DisasterScreens/ForestFirePage.dart';
import 'emergency_numbers.dart';
import 'location_page.dart';

class ENumbersPage extends StatefulWidget {
  const ENumbersPage({super.key});

  @override
  State<ENumbersPage> createState() => _ENumbersPageState();
}

class _ENumbersPageState extends State<ENumbersPage> {
  List<EmergencyNumber> filteredNumbers = emergencyNumbers;
  String searchText = "";

  final Map<String, Widget> disasterPages = {
    'Cyclone': const CyclonePage(),
    'Earthquakes': const EarthquakePage(),
    'Floods': const FloodPage(),
    'Forest Fires': const ForestFirePage(),
  };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        body: Padding( // Scaffold still needed for safe area, etc.
          padding: const EdgeInsets.only(
            top: 16.0,
            left: 0.0,
            right: 0.0,
            bottom: 16.0,
          ),
          child: Column( // Use a Column to place search bar and list
            children: [
               const Text("Disaster Hotspots Across India",style: TextStyle(
                 fontSize: 18,
                 fontWeight: FontWeight.bold,
               ),),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.23, // ~1/4 of screen height
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: disasterPages.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => entry.value,
                              ),
                            );
                          },
                          child: _buildDisasterCard(entry.key), // Your existing card builder
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SizedBox(
                  width: double.infinity,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LocationPage()),
                      );
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF43CEA2), Color(0xFF185A9D)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: const Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.insert_chart, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              "Generate Report",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text("Emergency Contacts",style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),),
              const SizedBox(height: 10),
              Padding( // Search bar padding
                padding: const EdgeInsets.only(bottom: 8.0,left: 16.0,right: 16.0), // Space below search bar
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
                      borderSide: const BorderSide(color: Colors.white, width: 2.0),
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
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFFFFFFF),
                              Color(0xFFFAD0C4),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Icon or leading section (Optional)
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.red.withOpacity(0.1),
                                child: const Icon(Icons.local_hospital, color: Colors.redAccent),
                              ),

                              const SizedBox(width: 16),

                              // Text content
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      emergencyNumber.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Color(0xFF1A1A1A),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      emergencyNumber.description,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF5C5C5C),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 10),

                              // Call button
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.redAccent.withOpacity(0.4),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.call, color: Colors.white),
                                  onPressed: () {
                                    _makePhoneCall(emergencyNumber.phoneNumber, context);
                                  },
                                ),
                              ),
                            ],
                          ),
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
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not make call.')),
        );
      }
    }
  }


  Widget _buildDisasterCard(String title) {
    // Map of titles to corresponding image URLs
    final Map<String, String> imageUrls = {
      'Cyclone': 'https://plus.unsplash.com/premium_photo-1727537538673-07a31d71efe3?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8Y3ljbG9uZXxlbnwwfHwwfHx8MA%3D%3D',
      'Earthquakes': 'https://thumbs.dreamstime.com/b/earthquake-cracked-asphalt-road-close-up-jagged-fissures-revealing-rocky-underlayment-scattered-debris-collapsed-330826185.jpg', // example
      'Floods': 'https://static01.nyt.com/images/2024/09/14/multimedia/15africa-floods-top/14africa-flooding-photos-1-qkml-superJumbo.jpg',       // example
      'Forest Fires': 'https://imgs.mongabay.com/wp-content/uploads/sites/30/2022/06/29103726/1200px-Bandipur_fires_2019.jpg', // example
    };

    // Fallback image if title is not found
    String imageUrl = imageUrls[title] ?? 'https://via.placeholder.com/400';

    return SizedBox(
      height: 140,
      width: 160,
      child: Card(
        elevation: 6,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        child: Stack(
          children: [
            // Background image with full fit
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.2),
                    BlendMode.darken,
                  ),
                ),
              ),
            ),

            // Gradient overlay for text readability
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.25),
                    Colors.transparent,
                    Colors.black.withOpacity(0.4),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            // Centered title
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                    shadows: [
                      Shadow(
                        blurRadius: 8,
                        color: Colors.black87,
                        offset: Offset(1, 2),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );


  }


}
class ColorFilters {
  static const grayscale = ColorFilter.matrix(<double>[
    0.2126,0.7152,0.0722,0,0,
    0.2126,0.7152,0.0722,0,0,
    0.2126,0.7152,0.0722,0,0,
    0,0,0,1,0,
  ]);
}
