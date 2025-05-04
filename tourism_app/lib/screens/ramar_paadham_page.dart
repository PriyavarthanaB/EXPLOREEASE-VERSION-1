import 'package:flutter/material.dart';

class RamarPaadhamPage extends StatefulWidget {
  const RamarPaadhamPage({Key? key}) : super(key: key);

  @override
  State<RamarPaadhamPage> createState() => _RamarPaadhamPageState();
}

class _RamarPaadhamPageState extends State<RamarPaadhamPage> {
  bool showFullText = false;

  final String fullContent = '''
Address: Ramar Paadham Temple, Gandhamadhana Parvatham, Rameswaram, Tamil Nadu 623526, India.

History: Ramar Paadham (also known as Gandhamadhana Parvatham) is a sacred spot believed to bear the footprints of Lord Rama. According to legend, Lord Rama stood here to survey the sea before building the bridge to Lanka. The temple atop this hill houses a stone footprint of Lord Rama and offers panoramic views of Rameswaram island.

Famous offerings: The site is revered by pilgrims and spiritual seekers. Apart from the holy footprint, it is known for its peaceful ambiance and elevated views of the coast. The location is ideal for sunrise or sunset visits, combining religious significance with scenic beauty.

Famous foods nearby:
- Sri Murugan Mess for authentic South Indian meals,
- Rameswaram Café for dosa, pongal, and idli,
- Street stalls selling mango slices with chili and local drinks,
- Hotel Vinayaga for vegetarian and North Indian options.
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDEDD2), // 🟤 Background
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDEDD2), // 🟤 Match background
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), // ⬅️ Black arrow
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🔶 Title container
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFF770A1D),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Ramar Paadham",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // 🟩 White text
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 🔶 Content container
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF770A1D), // 🟥 Content box background
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/Ramar padham.jpg', // Replace with your actual image
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
                      color: Colors.white, // 🟩 White content
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
                        color: Colors.white, // 🟩 White toggle
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