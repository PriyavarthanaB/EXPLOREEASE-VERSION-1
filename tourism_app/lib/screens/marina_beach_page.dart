import 'package:flutter/material.dart';

class MarinaBeachPage extends StatefulWidget {
  const MarinaBeachPage({Key? key}) : super(key: key);

  @override
  State<MarinaBeachPage> createState() => _MarinaBeachPageState();
}

class _MarinaBeachPageState extends State<MarinaBeachPage> {
  bool showFullText = false;

  final String fullContent = ''' 
Address: Marina Beach Road, Kamarajar Salai, Triplicane, Chennai, Tamil Nadu 600005, India.

History: Marina Beach in Chennai is one of the longest urban beaches in the world. It was developed in 1884 by Governor Grant Duff, who transformed it into a beautiful promenade. During British rule, it became a popular social spot with gardens and lights. Statues of Indian leaders and poets were later added. The beach also hosted public meetings and rallies. Today, it remains a major landmark, known for its beauty and historical importance.

Famous foods nearby: 
- Sundal from Rani Sundal Kadai, 
- Bajji from Jaya Bajji Stall, 
- Fish Fry from Marina Fish Fry Corner, 
- Murukku Sandwich from Murukku Sandwich Anna, 
- Sliced Raw Mangoes and Roasted Corn from Beachside Pushcarts.
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
                "Marina Beach",
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
                      'assets/marinabeach.jpeg',
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
