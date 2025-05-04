import 'package:flutter/material.dart';
import 'brihadeeshwarar_temple_page.dart';
import 'raja_raja_chola_gallery_page.dart';
import 'doll_making_center_page.dart';

class TanjorePlacesScreen extends StatelessWidget {
  const TanjorePlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDEDD2), // Updated background color
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDEDD2), // Match screen background
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
              "Famous Places in Tanjore",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF770A1D), // Title color
              ),
            ),
            const SizedBox(height: 20),

            // Place buttons
            _buildPlaceButton(
              context,
              title: "Brihadeeswarar Temple",
              icon: Icons.temple_hindu,
              destination: const BrihadeeswararTemplePage(),
            ),
            _buildPlaceButton(
              context,
              title: "Raja Raja Chola Art Gallery",
              icon: Icons.museum,
              destination: const RajaRajaCholaArtGalleryPage(),
            ),
            _buildPlaceButton(
              context,
              title: "Doll Making Center",
              icon: Icons.toys,
              destination: const DollMakingCenterPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceButton(BuildContext context, {
    required String title,
    required IconData icon,
    required Widget destination,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF770A1D), // Updated to maroon
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
