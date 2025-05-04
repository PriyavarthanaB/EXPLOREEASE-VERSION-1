import 'package:flutter/material.dart';
import 'danushkodi_page.dart';
import 'apj_kalam_memorial_page.dart';
import 'ramar_paadham_page.dart';

class RameshwaramPlacesScreen extends StatelessWidget {
  const RameshwaramPlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDEDD2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDEDD2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(
              child: Text(
                "Famous places in Rameshwaram",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF770A1D),
                ),
              ),
            ),
            const SizedBox(height: 30),

            _buildPlaceButton(
              context,
              title: "Danushkodi",
              icon: Icons.terrain,
              destination: const DhanushkodiPage(),
            ),
            _buildPlaceButton(
              context,
              title: "Dr. A.P.J Abdul Kalam Memorial",
              icon: Icons.museum,
              destination: const DrAPJAbdulKalamMemorialPage(),
            ),
            _buildPlaceButton(
              context,
              title: "Ramar Paadham",
              icon: Icons.temple_buddhist,
              destination: const RamarPaadhamPage(),
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
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF770A1D),
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          leading: Icon(icon, color: Colors.white),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
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
