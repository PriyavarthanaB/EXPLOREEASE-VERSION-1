import 'package:flutter/material.dart';

class KanchiKudilPage extends StatefulWidget {
  const KanchiKudilPage({Key? key}) : super(key: key);

  @override
  State<KanchiKudilPage> createState() => _KanchiKudilPageState();
}

class _KanchiKudilPageState extends State<KanchiKudilPage> {
  bool showFullText = false;

  final String fullContent = '''
Address: Kanchi Kudil, Sangeetha Vidwan Naina Pillai Street, Kanchipuram, Tamil Nadu 631502, India.

History: Kanchi Kudil is a heritage house converted into a museum that offers a glimpse into traditional Tamil Brahmin architecture and lifestyle. The house, over 90 years old, reflects the cultural, social, and familial practices of Kanchipuram’s past. Visitors can see antique furniture, kitchenware, and photos that preserve the essence of a bygone era. It’s a unique blend of living history and cultural documentation.

Famous offerings: Guided heritage tours, cultural performances, and exhibits on Tamil traditions. It's also a popular photography spot due to its authentic interiors and ambiance.

Famous foods nearby:
- Saravana Bhavan for traditional Tamil thali and pongal,
- Adyar Ananda Bhavan for sweets and snacks,
- Sri Krishna Sweets for mysurpa and mixture,
- Murugan Idli Shop for piping hot dosas and idlis.
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
                "Kanchi Kudil",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 🟨 Content container updated to 0xFF770A1D
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
                      'assets/kudil.jpg',
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
                    child: const Text(
                      "See more",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (showFullText)
                    const Text(
                      "See less",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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