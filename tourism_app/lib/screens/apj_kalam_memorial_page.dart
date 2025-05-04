import 'package:flutter/material.dart';

class DrAPJAbdulKalamMemorialPage extends StatefulWidget {
  const DrAPJAbdulKalamMemorialPage({Key? key}) : super(key: key);

  @override
  State<DrAPJAbdulKalamMemorialPage> createState() =>
      _DrAPJAbdulKalamMemorialPageState();
}

class _DrAPJAbdulKalamMemorialPageState
    extends State<DrAPJAbdulKalamMemorialPage> {
  bool showFullText = false;

  final String fullContent = '''
Address: Dr. A.P.J. Abdul Kalam National Memorial, Pei Karumbu, Rameswaram, Tamil Nadu 623526, India.

History: The Dr. A.P.J. Abdul Kalam Memorial is dedicated to the 11th President of India, fondly remembered as the “Missile Man.” It was inaugurated in 2017 and built by the DRDO (Defence Research and Development Organisation) to honor his legacy. The memorial showcases his journey from a humble fisherman’s son to the highest office in India, and his immense contribution to space and defense technology.

Famous offerings: The memorial combines Mughal and Indian architecture and houses replicas of rockets, photos of his achievements, and even his personal belongings. The site includes a library, meditation hall, and a life-size bronze statue of Kalam. It serves as both a museum and inspiration center.

Famous foods nearby:
- Hotel Gurupriya for veg thalis and South Indian meals,
- Nattukottai Mess for traditional Chettinad dishes,
- Abdul Kalam Street food stalls with local snacks and tea,
- Ariya Bhavan for dosa varieties and filter coffee.
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDEDD2), // 🟤 New background color
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
            // 🔶 Title box - now dark
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFF770A1D),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Dr. A.P.J. Abdul Kalam Memorial",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // 🟩 White text
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 🔶 Content box - now dark
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
                      'assets/kalam.jpg',
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
                        color: Colors.white, // 🟩 White toggle text
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