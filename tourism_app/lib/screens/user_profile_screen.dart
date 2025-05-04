import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileScreen extends StatelessWidget {
  final String userId;
  final String role; // 'guides' or 'tourists'

  const UserProfileScreen({super.key, required this.userId, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDEDD2),  // Beige background color
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove the back button and title bar
        backgroundColor: Colors.transparent, // Transparent AppBar to make it disappear
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection(role).doc(userId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final data = snapshot.data!.data() as Map<String, dynamic>?;

          if (data == null) {
            return const Center(child: Text('User not found.'));
          }

          return Center(  // Center the content on the screen
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Allow the Column to shrink to fit content
                crossAxisAlignment: CrossAxisAlignment.center, // Center the items horizontally
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: data['profileUrl'] != null
                        ? NetworkImage(data['profileUrl'])
                        : const AssetImage('assets/default_profile.png') as ImageProvider,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    data['username'] ?? 'Username',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF770A1D),  // Maroon color for the user profile text
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (data['country'] != null)
                    Text(
                      "Country: ${data['country']}",
                      style: const TextStyle(fontSize: 16, color: Color(0xFF770A1D)), // Maroon color for text
                    ),
                  if (data['language'] != null)
                    Text(
                      "Language: ${data['language']}",
                      style: const TextStyle(fontSize: 16, color: Color(0xFF770A1D)), // Maroon color for text
                    ),
                  if (data['bio'] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        "Bio: ${data['bio']}",
                        style: const TextStyle(fontSize: 16, color: Color(0xFF770A1D)), // Maroon color for text
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
