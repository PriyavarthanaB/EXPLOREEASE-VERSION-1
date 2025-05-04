import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TouristProfileScreen extends StatefulWidget {
  const TouristProfileScreen({super.key});

  @override
  State<TouristProfileScreen> createState() => _TouristProfileScreenState();
}

class _TouristProfileScreenState extends State<TouristProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  String? _selectedLanguage;
  String? _selectedCountry;

  bool _isLoading = true;

  final List<String> _languages = [
    "English",
    "Hindi",
    "Tamil",
    "Telugu",
    "French",
    "German",
    "Japanese"
  ];
  final List<String> _countries = [
    "India",
    "United States",
    "United Kingdom",
    "Canada",
    "Germany",
    "France",
    "Australia",
    "Japan"
  ];

  @override
  void initState() {
    super.initState();
    fetchTouristData();
  }

  Future<void> fetchTouristData() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        final doc =
        await FirebaseFirestore.instance.collection('tourists').doc(uid).get();
        if (doc.exists) {
          final data = doc.data()!;
          _emailController.text = data['email'] ?? '';
          _usernameController.text = data['username'] ?? '';
          _selectedLanguage = data['language'];
          _selectedCountry = data['country'];
        }
      }
    } catch (e) {
      print("Error fetching tourist data: $e");
    }
    setState(() => _isLoading = false);
  }

  Future<void> updateTouristData() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        await FirebaseFirestore.instance.collection('tourists').doc(uid).update({
          'email': _emailController.text.trim(),
          'username': _usernameController.text.trim(),
          'language': _selectedLanguage,
          'country': _selectedCountry,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully")),
        );
      }
    } catch (e) {
      print("Error updating tourist data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDEDD2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDEDD2),
        elevation: 0,
        leading: const BackButton(
          color: Color(0xFF770A1D), // ← maroon back arrow
        ),
        title: const Text(
          'Profile',
          style: TextStyle(color: Color(0xFF770A1D), fontSize: 24),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("You can't edit the email")),
                  );
                },
                child: AbsorbPointer(
                  child:
                  buildInputField(Icons.email, _emailController, "Email"),
                ),
              ),
              const SizedBox(height: 15),
              buildInputField(
                  Icons.account_circle, _usernameController, "Username"),
              const SizedBox(height: 15),
              buildDropdown("Language", _languages, _selectedLanguage,
                      (value) {
                    setState(() => _selectedLanguage = value);
                  }),
              const SizedBox(height: 15),
              buildDropdown("Country", _countries, _selectedCountry,
                      (value) {
                    setState(() => _selectedCountry = value);
                  }),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: updateTouristData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC77900),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30, vertical: 15),
                ),
                child:
                const Text("Submit", style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputField(
      IconData icon, TextEditingController controller, String label) =>
      TextFormField(
        controller: controller,
        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          filled: true,
          fillColor: const Color(0xFF770A1D),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        style: const TextStyle(color: Colors.white),
      );

  Widget buildDropdown(String label, List<String> items, String? selected,
      ValueChanged<String?> onChanged) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF770A1D),
          borderRadius: BorderRadius.circular(10),
        ),
        child: DropdownButtonFormField<String>(
          value: selected,
          items: items
              .map((item) => DropdownMenuItem(
            value: item,
            child: Text(item, style: const TextStyle(color: Colors.white)),
          ))
              .toList(),
          onChanged: onChanged,
          dropdownColor: const Color(0xFF770A1D),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.white),
            border: InputBorder.none,
          ),
          iconEnabledColor: Colors.white,
        ),
      );
}
