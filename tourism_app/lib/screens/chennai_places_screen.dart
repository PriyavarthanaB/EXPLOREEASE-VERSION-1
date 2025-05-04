import 'package:flutter/material.dart';
import 'marina_beach_page.dart';
import 'kapaleeshwarar_temple_page.dart';
import 'birla_planetarium_page.dart';
import 'select_guide_screen.dart';

class ChennaiPlacesScreen extends StatelessWidget {
  const ChennaiPlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDEDD2), // Updated background color
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDEDD2), // Same as background
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), // Arrow icon in black
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Famous places in Chennai",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF770A1D), // Updated title color
              ),
            ),
            const SizedBox(height: 20),

            // Place buttons
            _buildPlaceButton(
              context,
              title: "Marina Beach",
              icon: Icons.waves,
              destination: const MarinaBeachPage(),
            ),
            _buildPlaceButton(
              context,
              title: "Kapaleeshwarar Temple",
              icon: Icons.temple_hindu,
              destination: const KapaleeshwararTemplePage(),
            ),
            _buildPlaceButton(
              context,
              title: "Birla Planetarium",
              icon: Icons.travel_explore,
              destination: const BirlaPlanetariumPage(),
            ),

            // ✅ Removed the Spacer and Book Guide Button below
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceButton(BuildContext context, {
    required String title,
    required IconData icon,
    Widget? destination,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF770A1D), // Text box background color
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: Icon(icon, color: Colors.white), // Icon inside text field in white
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Text inside button in white
            ),
          ),
          onTap: destination != null
              ? () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => destination),
            );
          }
              : null,
        ),
      ),
    );
  }
}
