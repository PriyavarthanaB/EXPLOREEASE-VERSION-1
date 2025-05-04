import 'package:flutter/material.dart';

class VaradarajaPerumalTemplePage extends StatefulWidget {
  const VaradarajaPerumalTemplePage({Key? key}) : super(key: key);

  @override
  State<VaradarajaPerumalTemplePage> createState() => _VaradarajaPerumalTemplePageState();
}

class _VaradarajaPerumalTemplePageState extends State<VaradarajaPerumalTemplePage> {
  bool showFullText = false;

  final String fullContent = '''
Address: Varadaraja Perumal Temple, W Mada St, Little Kanchipuram, Kanchipuram, Tamil Nadu 631501, India.

History: The Varadaraja Perumal Temple is one of the Divya Desams, the 108 temples dedicated to Lord Vishnu, and holds immense spiritual significance in Vaishnavism. Built by the Cholas in the 11th century and later expanded by the Vijayanagar kings, the temple is known for its intricate carvings, towering gopurams, and the lizard sculptures believed to remove sins when touched. The temple's deity, Lord Varadaraja (a form of Vishnu), is depicted in a majestic standing posture.

Famous offerings: Devotees offer tulsi garlands, ghee lamps, and perform Vishnu Sahasranama chants. The Athi Varadar, a wooden idol displayed once every 40 years, draws lakhs of pilgrims.

Famous foods nearby:
- Murugan Idli Shop’s medu vada and chutneys,
- Sangeetha Veg for mini tiffin combo and coffee,
- Saravana Bhavan for ghee roast and kesari,
- Bala's Bakery for sweet buns and snacks.
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
                "Varadaraja Perumal Temple",
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
                      'assets/perumal.jpg',
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