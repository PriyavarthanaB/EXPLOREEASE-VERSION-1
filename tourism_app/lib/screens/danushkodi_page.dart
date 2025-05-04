import 'package:flutter/material.dart';

class DhanushkodiPage extends StatefulWidget {
  const DhanushkodiPage({Key? key}) : super(key: key);

  @override
  State<DhanushkodiPage> createState() => _DhanushkodiPageState();
}

class _DhanushkodiPageState extends State<DhanushkodiPage> {
  bool showFullText = false;

  final String fullContent = '''
Address: Dhanushkodi, Rameswaram, Ramanathapuram District, Tamil Nadu 623526, India.

History: Dhanushkodi is a ghost town at the southeastern tip of Pamban Island, Tamil Nadu. Once a bustling town, it was destroyed during the 1964 Rameswaram cyclone. Known for its mythological and historical significance, it is believed to be the place where Lord Rama built the Ram Setu (Adam's Bridge) to Lanka. The remains of the railway station, church, and homes tell tales of a tragic past, while the scenic seashore attracts tourists year-round.

Famous offerings: Panoramic views of the Bay of Bengal and Indian Ocean meeting, spiritual and mythological significance, ruins of the old town, and photo ops with a surreal landscape. It's also famous for its sunrise views and the last road of India.

Famous foods nearby:
- Street-side stalls with spicy fish fry and prawn curry,
- Rameswaram's Hotel Tamilnadu for South Indian meals,
- Sri Murugan Mess for home-style seafood,
- Local coconut vendors for fresh coconut water on the beach.
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDEDD2), // ✅ Updated background color
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDEDD2), // ✅ Match background
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), // ✅ Black arrow
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
                color: const Color(0xFF770A1D), // ✅ Title box color updated
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Dhanushkodi",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // ✅ White text
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 🟨 Content container
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF770A1D), // ✅ Content box color updated
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/dhanushkodi.jpg',
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
                      color: Colors.white, // ✅ White content text
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
                        color: Colors.white, // ✅ White toggle text
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