import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // ✅ Added for Firestore
import 'chennai_places_screen.dart';
import 'tanjore_screen.dart';
import 'kanchipuram_places_screen.dart';
import 'madurai_places_screen.dart';
import 'rameshwaram_places_screen.dart';
import 'select_guide_screen.dart';
import 'tourist_profile_screen.dart';
import 'help_screen.dart';
import 'about_us_page.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, String>> places = const [
    {"name": "CHENNAI", "image": "assets/chennai.jpeg"},
    {"name": "TANJORE", "image": "assets/tanjore.jpg"},
    {"name": "KANCHIPURAM", "image": "assets/kanchipuram.jpg"},
    {"name": "MADURAI", "image": "assets/madurai.jpeg"},
    {"name": "RAMESHWARAM", "image": "assets/rameshwaram.jpg"},
  ];

  String searchQuery = '';

  List<Map<String, String>> get filteredPlaces {
    return places
        .where((place) =>
        place['name']!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  // ✅ Get user role from Firestore
  Future<String> _getUserRole(String uid) async {
    final touristDoc =
    await FirebaseFirestore.instance.collection('tourists').doc(uid).get();
    if (touristDoc.exists) return 'tourists';

    final guideDoc =
    await FirebaseFirestore.instance.collection('guides').doc(uid).get();
    if (guideDoc.exists) return 'guides';

    return 'unknown';
  }

  // ✅ Updated logout function with Firestore update
  void _logout() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final role = await _getUserRole(user.uid);
      if (role != 'unknown') {
        await FirebaseFirestore.instance.collection(role).doc(user.uid).update({
          'isOnline': false,
          'lastSeen': Timestamp.now(),
        });
      }
    }

    await FirebaseAuth.instance.signOut();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
    );
  }

  // ✅ Logout dialog using the updated _logout function
  void _logoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop(); // Close dialog first
              _logout(); // Call custom logout function
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFFDEDD2),
      drawer: Drawer(
        backgroundColor: const Color(0xFFFDEDD2),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF770A1D),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'EXPLORE EASE',
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TouristProfileScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text('Book Guide'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SelectGuideScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Help'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HelpScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About Us'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutUsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log out'),
              onTap: () => _logoutDialog(context),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.black),
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF770A1D),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: TextField(
                  onChanged: (query) {
                    setState(() {
                      searchQuery = query;
                    });
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    icon: Icon(Icons.search, color: Colors.white),
                    hintText: "Search places",
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: filteredPlaces.isEmpty
                    ? const Center(
                  child: Text(
                    "No results found",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                )
                    : ListView.builder(
                  itemCount: filteredPlaces.length,
                  itemBuilder: (context, index) {
                    final placeName = filteredPlaces[index]['name'];
                    final placeImage = filteredPlaces[index]['image'];

                    return GestureDetector(
                      onTap: () {
                        if (placeName == 'CHENNAI') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                const ChennaiPlacesScreen()),
                          );
                        } else if (placeName == 'TANJORE') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                const TanjorePlacesScreen()),
                          );
                        } else if (placeName == 'KANCHIPURAM') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                const KanchipuramPlacesScreen()),
                          );
                        } else if (placeName == 'MADURAI') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                const MaduraiPlacesScreen()),
                          );
                        } else if (placeName == 'RAMESHWARAM') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                const RameshwaramPlacesScreen()),
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: Image.asset(
                            placeImage!,
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
