import 'package:flutter/material.dart';

class BrihadeeswararTemplePage extends StatefulWidget {
  const BrihadeeswararTemplePage({Key? key}) : super(key: key);

  @override
  State<BrihadeeswararTemplePage> createState() => _BrihadeeswararTemplePageState();
}

class _BrihadeeswararTemplePageState extends State<BrihadeeswararTemplePage> {
  bool showFullText = false;

  final String fullContent = '''
Address: Brihadeeswarar Temple, Balaganapathy Nagar, Thanjavur, Tamil Nadu 613007, India.

History: The Brihadeeswarar Temple, built by Raja Raja Chola I in the 11th century, is one of the greatest architectural marvels of South India. Dedicated to Lord Shiva, this UNESCO World Heritage Site is renowned for its massive vimana (temple tower), which stands over 200 feet tall, and the enormous Nandi statue carved from a single stone. The temple is a brilliant example of Chola architecture and showcases advanced engineering, murals, and bronze sculptures.

Famous offerings: Devotees offer ghee lamps, vibuthi (sacred ash), flowers, and coconuts. Traditional temple prasadam like tamarind rice (Puliyodarai) and sweet Pongal is also available.

Famous foods nearby:
- Sree Ariya Bhavan’s mini meals and ghee roast dosa,
- Sathars Restaurant’s biryani and parotta curry,
- Thillana’s South Indian buffet,
- Vasantha Bhavan’s filter coffee and pongal-vada combo.
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
                "Brihadeeswarar Temple",
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
                      'assets/big_temple.jpg',
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