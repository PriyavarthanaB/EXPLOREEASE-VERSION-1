import 'package:flutter/material.dart';

class KamakshiAmmanTemplePage extends StatefulWidget {
  const KamakshiAmmanTemplePage({Key? key}) : super(key: key);

  @override
  State<KamakshiAmmanTemplePage> createState() => _KamakshiAmmanTemplePageState();
}

class _KamakshiAmmanTemplePageState extends State<KamakshiAmmanTemplePage> {
  bool showFullText = false;

  final String fullContent = '''
Address: Kamakshi Amman Temple, Sannathi St, Kanchipuram, Tamil Nadu 631502, India.

History: The Kamakshi Amman Temple in Kanchipuram is one of the most important shrines dedicated to Goddess Parvati, worshipped here as Kamakshi. Built in the 6th century by the Pallavas and later expanded by the Cholas, this temple is one of the 51 Shakti Peethas and a major spiritual center in South India. The main sanctum houses the deity seated in Padmasana (lotus posture), signifying peace and prosperity.

Famous offerings: Devotees offer kumkum, bangles, sarees, and lemon garlands. Special poojas like Sahasranama Archana and Lalitha Trishati are regularly performed.

Famous foods nearby:
- Saravana Bhavan’s South Indian thali and pongal-vada combo,
- Murugan Idli Shop for soft idlis and chutneys,
- Hotel Vasanta Bhavan’s rava dosa and coffee,
- A2B for mini meals and sweets like jangri and kesari.
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
            // 🟫 Title in separate box
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFF770A1D),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Kamakshi Amman Temple",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 🟨 Content container
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
                      'assets/kanchi.jpg',
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