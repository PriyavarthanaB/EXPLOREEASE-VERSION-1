import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'home_screen.dart';
import 'guide_availability_screen.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  @override
  void initState() {
    super.initState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📩 Foreground message: ${message.notification?.title}');
      print('📝 Message body: ${message.notification?.body}');
    });
  }

  Future<void> _saveUserRole(BuildContext context, String selectedRole) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not logged in.")),
      );
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final userData = doc.data();
      if (userData == null) {
        throw Exception("User data not found.");
      }

      final userMap = {
        'uid': user.uid,
        'username': userData['username'],
        'email': user.email,
        'country': userData['country'],
        'language': userData['language'],
        'role': selectedRole,
      };

      final collection = selectedRole == 'Tourist' ? 'tourists' : 'guides';

      await FirebaseFirestore.instance
          .collection(collection)
          .doc(user.uid)
          .set(userMap);

      print('✅ Role saved to $collection collection in Firestore');

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'role': selectedRole});

      print('✅ Role also updated in users collection');

      // Navigation
      if (selectedRole == 'Tourist') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const GuideAvailabilityScreen()),
        );
      }
    } catch (e) {
      print('❌ Error saving user role: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Specify Your Role',
                style: TextStyle(
                    fontSize: 24,
                    color: Color(0xFF770A1D),
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              _roleButton(
                context,
                label: "Tourist",
                icon: Icons.travel_explore,
                onTap: () => _saveUserRole(context, 'Tourist'),
              ),
              const SizedBox(height: 20),
              _roleButton(
                context,
                label: "Guide",
                icon: Icons.tour,
                onTap: () => _saveUserRole(context, 'Guide'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roleButton(
      BuildContext context, {
        required String label,
        required IconData icon,
        required VoidCallback onTap,
      }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF770A1D),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
