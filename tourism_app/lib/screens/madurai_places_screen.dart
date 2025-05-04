import 'package:flutter/material.dart';
import 'meenakshi_amman_temple_page.dart';
import 'thirumal_nayakar_temple_page.dart';
import 'gandhi_memorial_museum_page.dart';

class MaduraiPlacesScreen extends StatelessWidget {
  const MaduraiPlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDEDD2), // Background updated
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDEDD2), // Match background
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), // Arrow in black
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Famous places in Madurai",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF770A1D), // Title in maroon
              ),
            ),
            const SizedBox(height: 20),

            // Place buttons with navigation
            _buildPlaceButton(
              context,
              title: "Meenakshi Amman Temple",
              icon: Icons.temple_hindu,
              destination: const MeenakshiAmmanTemplePage(),
            ),
            _buildPlaceButton(
              context,
              title: "Thirumalai Nayakar Temple",
              icon: Icons.temple_hindu,
              destination: const ThirumalaiNayakkarMahalPage(),
            ),
            _buildPlaceButton(
              context,
              title: "Gandhi Memorial Museum",
              icon: Icons.museum,
              destination: const GandhiMemorialMuseumPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceButton(
      BuildContext context, {
        required String title,
        required IconData icon,
        required Widget destination,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF770A1D), // Text box in maroon
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: Icon(icon, color: Colors.white), // Icon in white
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Text in white
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => destination),
            );
          },
        ),
      ),
    );
  }
}
