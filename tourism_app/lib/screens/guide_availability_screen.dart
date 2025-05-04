import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'guide_home_screen.dart';

class GuideAvailabilityScreen extends StatefulWidget {
  const GuideAvailabilityScreen({super.key});

  @override
  State<GuideAvailabilityScreen> createState() => _GuideAvailabilityScreenState();
}

class _GuideAvailabilityScreenState extends State<GuideAvailabilityScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<String> _timeSlots = [
    '8:00 AM to 12:00 PM',
    '12:00 PM to 4:00 PM',
    '4:00 PM to 11:55 PM'
  ];

  List<String> _selectedSlots = [];
  String? _languageFromDB;
  String? _usernameFromDB;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _fetchGuideData();
  }

  Future<void> _fetchGuideData() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    try {
      final doc = await FirebaseFirestore.instance.collection('guides').doc(uid).get();
      final userData = doc.data();
      setState(() {
        _languageFromDB = userData?['language'] ?? 'Not available';
        _usernameFromDB = userData?['username'] ?? 'Guide';
        _selectedSlots = List<String>.from(userData?['availability'] ?? []);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load data: ${e.toString()}")),
      );
    }
  }

  Future<void> _submitData() async {
    if (_selectedSlots.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one time slot.")),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return;

      await FirebaseFirestore.instance.collection('guides').doc(uid).update({
        'availability': _selectedSlots, // ✅ list stored correctly
        'language': _languageFromDB,
        'isAvailable': true, // ✅ ensure availability flag is true
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Availability saved successfully!")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const GuideHomeScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving data: ${e.toString()}")),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9EC),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.account_circle_outlined,
                  size: 80, color: Color(0xFF600000)),
              const SizedBox(height: 20),

              Text(
                _usernameFromDB ?? "Guide",
                style: const TextStyle(
                    fontSize: 24,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF600000)),
              ),
              const SizedBox(height: 30),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Select your available time slots:",
                  style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF600000)),
                ),
              ),
              const SizedBox(height: 10),

              ..._timeSlots.map((slot) => CheckboxListTile(
                title: Text(slot, style: const TextStyle(color: Colors.black)),
                value: _selectedSlots.contains(slot),
                onChanged: (bool? value) => setState(() {
                  if (value!) {
                    _selectedSlots.add(slot);
                  } else {
                    _selectedSlots.remove(slot);
                  }
                }),
              )).toList(),

              const SizedBox(height: 30),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Language spoken",
                  style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF600000)),
                ),
              ),
              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF600000),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _languageFromDB ?? "Loading...",
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),

              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: _loading ? null : _submitData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                ),
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.black)
                    : const Text("Save Availability",
                    style: TextStyle(fontSize: 18, color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
