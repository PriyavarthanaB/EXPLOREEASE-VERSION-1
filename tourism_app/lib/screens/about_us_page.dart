import 'package:flutter/material.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  bool _isExpanded = false;

  final String aboutUsText = '''
Introduction:
We are a team of M.Sc. Computer Science students from the College of Engineering, Guindy, Anna University. This application is developed as part of our Software Engineering project, with a vision to enhance travel experiences through smart technology.

Our app connects tourists with local. We believe that travel should be more than ticking off locations; it should be about meaningful experiences.

Mission:
At Explore Ease, we connect curious travelers with passionate local guides to create authentic, memorable travel experiences. We believe that every journey should be more than sightseeing — it should be a story worth telling.

Vision:
Born out of a love for exploration and cultural exchange, our team created this platform to bridge the gap between travelers and local experts. Whether you're chasing hidden gems or iconic landmarks, our guides bring destinations to life.

Our Team,
Contact Us - enquireexploreease01@gmail.com
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDEDD2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDEDD2),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF770A1D)),
        title: const Text(
          'About Us',
          style: TextStyle(
            color: Color(0xFF770A1D),
            fontSize: 24,
            //fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // ✅ AnimatedContainer instead of fixed height
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              constraints: BoxConstraints(
                maxHeight: _isExpanded ? 500 : 250,
              ),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF770A1D),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  // ✅ Scroll view only if content overflows
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        aboutUsText,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                      child: Text(
                        _isExpanded ? "See Less" : "See More",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
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
