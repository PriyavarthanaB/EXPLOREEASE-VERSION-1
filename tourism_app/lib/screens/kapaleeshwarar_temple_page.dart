import 'package:flutter/material.dart';

class KapaleeshwararTemplePage extends StatefulWidget {
  const KapaleeshwararTemplePage({Key? key}) : super(key: key);

  @override
  State<KapaleeshwararTemplePage> createState() => _KapaleeshwararTemplePageState();
}

class _KapaleeshwararTemplePageState extends State<KapaleeshwararTemplePage> {
  bool showFullText = false;

  final String fullContent = '''
Address: Kapaleeshwarar Temple, Vinayaka Nagar Colony, Mylapore, Chennai, Tamil Nadu 600004, India.

History: The Kapaleeshwarar Temple is a historic Hindu temple dedicated to Lord Shiva, located in Mylapore, Chennai. Built around the 7th century CE by the Pallavas and later rebuilt by the Vijayanagara kings, the temple showcases Dravidian architecture with a towering gopuram. It is associated with many legends, including that of Goddess Parvati worshipping Shiva in the form of a peacock. The temple is an important cultural and religious center, attracting devotees and tourists alike.

Famous offerings: Coconut, Flowers, Puliyodarai (tamarind rice), Pongal, and traditional sweets sold by nearby vendors.

Famous foods nearby: Karpagambal Mess’s filter coffee and idli-sambar, Rayar’s Café’s rava dosa, Murugan Idli Shop’s soft idlis, and authentic South Indian thali meals around Mylapore.
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
                "Kapaleeshwarar Temple",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 🟨 Content container with updated color
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
                      'assets/kapaleeshwarar.jpg',
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