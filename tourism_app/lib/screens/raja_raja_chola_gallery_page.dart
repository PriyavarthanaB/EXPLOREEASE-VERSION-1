import 'package:flutter/material.dart';

class RajaRajaCholaArtGalleryPage extends StatefulWidget {
  const RajaRajaCholaArtGalleryPage({Key? key}) : super(key: key);

  @override
  State<RajaRajaCholaArtGalleryPage> createState() => _RajaRajaCholaArtGalleryPageState();
}

class _RajaRajaCholaArtGalleryPageState extends State<RajaRajaCholaArtGalleryPage> {
  bool showFullText = false;

  final String fullContent = '''
Address: Raja Raja Chola Art Gallery, East Main Street, Thanjavur Palace Complex, Thanjavur, Tamil Nadu 613009, India.

History: The Raja Raja Chola Art Gallery is housed within the Thanjavur Palace complex and is a treasure trove of South Indian heritage. It showcases an impressive collection of bronze statues, stone sculptures, and artifacts from the Chola, Nayak, and Maratha periods. Many pieces, especially the Chola bronzes, are globally renowned for their artistry and spiritual significance. The gallery is divided into sections like the Bronze Gallery, Stone Gallery, and the Painting Gallery.

Famous offerings: Visitors admire rare Nataraja sculptures, ancient Tamil inscriptions, and stunning Tanjore paintings. Photography is allowed with permission, and guided tours are available.

Famous foods nearby:
- Hotel Gnanam’s South Indian thali and curd rice,
- Vasantha Bhavan’s crispy dosa and mini meals,
- Sathars for chicken curry and parottas,
- Sri Krishna Bhavan’s idiyappam with coconut milk.
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
                "Raja Raja Chola Art Gallery",
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
                      'assets/rajarajacholaart gallery.jpg',
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