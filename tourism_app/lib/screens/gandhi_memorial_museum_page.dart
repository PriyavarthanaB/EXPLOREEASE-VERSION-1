import 'package:flutter/material.dart';

class GandhiMemorialMuseumPage extends StatefulWidget {
  const GandhiMemorialMuseumPage({Key? key}) : super(key: key);

  @override
  State<GandhiMemorialMuseumPage> createState() => _GandhiMemorialMuseumPageState();
}

class _GandhiMemorialMuseumPageState extends State<GandhiMemorialMuseumPage> {
  bool showFullText = false;

  final String fullContent = '''
Address: Gandhi Memorial Museum, Tamukkam Palace, Madurai, Tamil Nadu 625020, India.

History: Gandhi Memorial Museum is one of the five Gandhi Sanghralayas in the country and is housed in the historic Tamukkam Palace. It was established in 1959 and showcases the life and teachings of Mahatma Gandhi. The museum features a rich collection of photographs, letters, manuscripts, and articles used by Gandhi, including a piece of blood-stained cloth worn by him at the time of his assassination.

Famous offerings: The museum has a special section titled “India Fights for Freedom” with over 265 illustrations. It also hosts educational programs, exhibitions, and documentaries on Gandhian philosophy and non-violence.

Famous foods nearby:
- Murugan Idli Shop for idlis and dosas,
- Simmakkal Konar Kadai for spicy Madurai specials,
- Ayyappan Tiffin Centre for authentic South Indian breakfasts,
- Prema Vilas for halwa and savory snacks.
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
                color: const Color(0xFF770A1D), // ✅ Updated title box color
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Gandhi Memorial Museum",
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
                color: const Color(0xFF770A1D), // ✅ Updated content box color
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/memorial.jpg',
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
                        color: Colors.white, // ✅ White see more/less text
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