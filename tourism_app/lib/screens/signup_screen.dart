import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'email_verification_waiting_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  bool _isLoading = false;
  bool _isPasswordVisible = false;

  String _selectedCountry = 'India';
  String _selectedLanguage = 'English';

  final List<String> countryList = [
    "India", "United States", "United Kingdom", "Canada", "Germany",
    "France", "Australia", "Japan"
  ];

  final List<String> languageList = [
    "English", "Hindi", "Tamil", "Telugu", "French",
     "German", "Japanese"
  ];

  Future<void> _signUp() async {
    setState(() => _isLoading = true);

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await userCredential.user!.sendEmailVerification();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'username': _usernameController.text.trim(),
        'email': _emailController.text.trim(),
        'country': _selectedCountry,
        'language': _selectedLanguage,
        'createdAt': FieldValue.serverTimestamp(),
        'isEmailVerified': false,
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const EmailVerificationWaitingScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Signup failed';
      if (e.code == 'email-already-in-use') {
        errorMessage = 'Email already in use.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'Weak password.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Invalid email address.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDEDD2), // Updated background color
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "SIGN UP",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF770A1D), // Updated title color
                ),
              ),
              const SizedBox(height: 30),

              _buildTextField(_usernameController, "Username"),
              const SizedBox(height: 15),

              _buildTextField(_emailController, "Email", TextInputType.emailAddress),
              const SizedBox(height: 15),

              _buildPasswordField(),
              const SizedBox(height: 15),

              _buildDropdown("Country", _selectedCountry, countryList, (value) {
                setState(() => _selectedCountry = value!);
              }),
              const SizedBox(height: 15),

              _buildDropdown("Language", _selectedLanguage, languageList, (value) {
                setState(() => _selectedLanguage = value!);
              }),
              const SizedBox(height: 25),

              ElevatedButton(
                onPressed: _isLoading ? null : _signUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC77900), // Updated button color
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.black)
                    : const Text("Sign Up", style: TextStyle(fontSize: 18, color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, [TextInputType keyboardType = TextInputType.text]) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white), // White input text
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white), // White label
        filled: true,
        fillColor: const Color(0xFF770A1D), // Updated field color
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      style: const TextStyle(color: Colors.white), // White input text
      decoration: InputDecoration(
        labelText: "Password",
        labelStyle: const TextStyle(color: Colors.white), // White label
        filled: true,
        fillColor: const Color(0xFF770A1D), // Updated field color
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.white, // Updated icon color
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String selectedValue, List<String> items, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      dropdownColor: const Color(0xFF770A1D), // Optional: dropdown menu color
      style: const TextStyle(color: Colors.white), // Text color
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white), // Label text white
        filled: true,
        fillColor: const Color(0xFF770A1D), // Field fill color
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onChanged: onChanged,
      items: items.map((value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: const TextStyle(color: Colors.white)), // Dropdown item text white
        );
      }).toList(),
    );
  }
}