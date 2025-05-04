import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'guide_profile_page.dart';
import 'login_screen.dart';
import 'about_us_page.dart';
import 'view_rating_screen.dart';
import 'guide_requests_screen.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: const Center(child: Text("Profile Page")),
    );
  }
}

class ViewRatingPage extends StatelessWidget {
  const ViewRatingPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("View Rating")),
      body: const Center(child: Text("Rating Page")),
    );
  }
}

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About Us")),
      body: const Center(child: Text("About Us Page")),
    );
  }
}

class GuideHomeScreen extends StatefulWidget {
  const GuideHomeScreen({super.key});

  @override
  State<GuideHomeScreen> createState() => _GuideHomeScreenState();
}

class _GuideHomeScreenState extends State<GuideHomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<String> notifiedBookingIds = [];
  int bookingCount = 0;

  @override
  void initState() {
    super.initState();
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      updateGuideLoginStatus(currentUser.uid);
    }
  }

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
              Navigator.of(ctx).pop();
              await _logout(context);
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  void _showInAppNotification(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // grab the guide's uid once, to pass into ViewRatingScreen
    final guideUid = _auth.currentUser!.uid;

    return Scaffold(
      backgroundColor: const Color(0xFFFDEDD2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDEDD2),
        elevation: 0,
        title: const Text(
          'EXPLORE EASE',
          style: TextStyle(
            color: Color(0xFF770A1D),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('bookings')
                .where('guideUid', isEqualTo: guideUid)
                .where('status', isEqualTo: 'pending')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                bookingCount = snapshot.data!.docs.length;
              }

              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications, color: Color(0xFF770A1D)),
                    onPressed: () {
                      // no change here
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const GuideRequestsScreen()),
                      );
                    },
                  ),
                  if (bookingCount > 0)
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                        child: Text(
                          '$bookingCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFFFDEDD2),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF770A1D)),
              child: Text(
                'EXPLORE EASE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GuideProfileScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('View Rating'),
              onTap: () {
                // pass the guideUid into your ViewRatingScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ViewRatingScreen(guideId: guideUid),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About Us'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AboutUsScreen()),
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
      body: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'WELCOME  TO\nEXPLORE EASE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF770A1D),
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 30),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/travel.jpeg',
                  width: 300,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Kindly check your booking requests',
                style: TextStyle(
                  color: Color(0xFF770A1D),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.pan_tool_alt, color: Color(0xFF770A1D), size: 30),
                  SizedBox(width: 10),
                  Icon(Icons.notifications_active, color: Color(0xFF770A1D), size: 30),
                ],
              ),
              const SizedBox(height: 30),
              StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('bookings')
                    .where('guideUid', isEqualTo: guideUid)
                    .where('status', isEqualTo: 'pending')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const SizedBox.shrink();

                  final bookings = snapshot.data!.docs;

                  for (var booking in bookings) {
                    final bookingId = booking.id;
                    final touristName = booking['touristName'];

                    if (!notifiedBookingIds.contains(bookingId)) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _showInAppNotification(context, 'New booking request from $touristName.');
                      });
                      notifiedBookingIds.add(bookingId);
                    }
                  }

                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final role = await _getUserRole(user.uid);
      await FirebaseFirestore.instance.collection(role).doc(user.uid).update({
        'isOnline': false,
        'lastSeen': Timestamp.now(),
      });
    }

    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
    );
  }

  Future<String> _getUserRole(String uid) async {
    final guideDoc = await FirebaseFirestore.instance.collection('guides').doc(uid).get();
    if (guideDoc.exists) return 'guides';

    final touristDoc = await FirebaseFirestore.instance.collection('tourists').doc(uid).get();
    if (touristDoc.exists) return 'tourists';

    return 'users'; // default fallback
  }
}

void updateGuideLoginStatus(String guideId) async {
  await FirebaseFirestore.instance.collection('guides').doc(guideId).update({
    'isAvailable': true,
    'isOnline': true,
    'lastLogin': Timestamp.now(),
    'currentBookingId': null,
  });
  print('✅ Guide login status updated for $guideId');
}
