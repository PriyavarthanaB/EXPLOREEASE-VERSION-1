import 'package:flutter/material.dart';

class ThirumalaiNayakkarMahalPage extends StatefulWidget {
  const ThirumalaiNayakkarMahalPage({Key? key}) : super(key: key);

  @override
  State<ThirumalaiNayakkarMahalPage> createState() => _ThirumalaiNayakkarMahalPageState();
}

class _ThirumalaiNayakkarMahalPageState extends State<ThirumalaiNayakkarMahalPage> {
  bool showFullText = false;

  final String fullContent = '''
Address: Thirumalai Nayakkar Mahal, Near Meenakshi Temple, Madurai, Tamil Nadu 625001, India.

History: Built in 1636 by King Thirumalai Nayak, this majestic palace reflects a blend of Dravidian and Islamic architectural styles. It was originally four times bigger, but only the central portion survives today. It served as the residence of the Nayak dynasty and was a key political center in Madurai.

Famous offerings: The palace is renowned for its grand pillars, domed ceilings, and decorative arches. The courtyard and throne room are especially impressive. A sound-and-light show narrates the story of Silappathikaram in the evenings. Visitors can admire the architectural finesse and royal ambiance.

Famous foods nearby:
- Murugan Idli Shop for soft idlis and chutneys,
- Amma Mess for non-veg Chettinad dishes,
- Sree Sabarees for veg meals and parotta,
- Jigarthanda stalls for Madurai’s iconic cold drink.
''';

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🟥 Title container (updated color)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFF770A1D),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Thirumalai Nayakkar Mahal",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 🟫 Content container (updated color)
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF770A1D),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/thirumalainayakkarmahal.jpg', // Replace with your image path
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    showFullText
                        ? fullContent
                        : fullContent.substring(0, 170) + "...",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showFullText = !showFullText;
                      });
                    },
                    child: Text(
                      showFullText ? "See less" : "See more",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}