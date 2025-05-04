import 'package:flutter/material.dart';

class MeenakshiAmmanTemplePage extends StatefulWidget {
  const MeenakshiAmmanTemplePage({Key? key}) : super(key: key);

  @override
  State<MeenakshiAmmanTemplePage> createState() => _MeenakshiAmmanTemplePageState();
}

class _MeenakshiAmmanTemplePageState extends State<MeenakshiAmmanTemplePage> {
  bool showFullText = false;

  final String fullContent = '''
Address: Meenakshi Amman Temple, Madurai Main, Madurai, Tamil Nadu 625001, India.

History: Meenakshi Amman Temple is a historic Hindu temple located on the southern bank of the Vaigai River in the temple city of Madurai. Dedicated to Goddess Meenakshi (a form of Parvati) and Lord Sundareswarar (a form of Shiva), the temple is a symbol of Tamil architecture and spiritual heritage. Originally built by the Pandya king Kulasekara, it was expanded significantly during the Nayak rule in the 16th century. The temple is famous for its stunning gopurams, thousand-pillar hall, and intricately carved sculptures.

Famous offerings: Devotees offer jasmine garlands, turmeric, and bangles. The temple is renowned for rituals like the Meenakshi Thirukalyanam (celestial wedding) and daily abhishekam and archanai ceremonies.

Famous foods nearby:
- Murugan Idli Shop for fluffy idlis and podi dosa,
- Amma Mess for mutton curry and biryani,
- Sree Sabarees for South Indian thali and parotta,
- Jigarthanda stalls for the iconic Madurai dessert drink.
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
            // 🟥 Title box with updated colors
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFF770A1D),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Meenakshi Amman Temple",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 🟫 Content box with updated colors
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
                      'assets/meenashi_tem.jpg',
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