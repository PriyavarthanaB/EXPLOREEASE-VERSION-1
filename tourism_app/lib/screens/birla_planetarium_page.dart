import 'package:flutter/material.dart';

class BirlaPlanetariumPage extends StatefulWidget {
  const BirlaPlanetariumPage({Key? key}) : super(key: key);

  @override
  State<BirlaPlanetariumPage> createState() => _BirlaPlanetariumPageState();
}

class _BirlaPlanetariumPageState extends State<BirlaPlanetariumPage> {
  bool showFullText = false;

  final String fullContent = '''
Address: B.M. Birla Planetarium, Gandhi Mandapam Road, Kotturpuram, Chennai, Tamil Nadu 600025, India.

History: The B.M. Birla Planetarium in Chennai was inaugurated in 1988 and is a major attraction for science and space enthusiasts. Located within the Periyar Science and Technology Centre, it offers shows in multiple languages and covers topics ranging from astronomy to physics and the solar system. The dome-shaped structure is equipped with modern audio-visual technology and hosts regular science exhibitions and educational programs.

Famous offerings: Visitors enjoy science demos, 3D space shows, and interactive exhibits on astronomy and energy. It's a hub for school trips and curious minds.

Famous foods nearby: 
- Murugan Idli Shop's ghee podi idlis and pongal,
- Sangeetha Veg Restaurant’s mini tiffin,
- Hot Chips' masala dosa and coffee,
- A2B’s (Adyar Ananda Bhavan) sweets and snacks near Adyar.
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
                "Birla Planetarium",
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
                      'assets/birla planetarium.jpg',
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