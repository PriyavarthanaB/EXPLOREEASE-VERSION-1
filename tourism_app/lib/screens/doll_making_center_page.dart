import 'package:flutter/material.dart';

class DollMakingCenterPage extends StatefulWidget {
  const DollMakingCenterPage({Key? key}) : super(key: key);

  @override
  State<DollMakingCenterPage> createState() => _DollMakingCenterPageState();
}

class _DollMakingCenterPageState extends State<DollMakingCenterPage> {
  bool showFullText = false;

  final String fullContent = '''
Address: Traditional Doll Making Center, Rameswaram, Tamil Nadu 623526, India.

History: The Doll Making Center in Rameswaram preserves the centuries-old craft of handmade dolls, often created from clay, cloth, and natural materials. These dolls depict mythological characters, village scenes, and folk tales. The center also provides training for local artisans, empowering them to carry forward this artistic heritage.

Famous offerings: Visitors can watch artisans at work, shaping and painting intricate dolls with traditional techniques. The center often sells handcrafted souvenirs, making it a great spot for cultural shopping. Some dolls are used in religious festivals and traditional storytelling (Bommalattam).

Famous foods nearby:
- Hotel Siva Sakthi for vegetarian meals and snacks,
- Seashore Restaurant for seafood lovers,
- Local tea shops with hot vadas and bajjis,
- Murugan Bhavan for South Indian breakfast and sweets.
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
                "Doll Making Center",
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
                      'assets/doll_making_center.jpg', // Replace with your actual image
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