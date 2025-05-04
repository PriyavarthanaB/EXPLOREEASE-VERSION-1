import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'role_selection_screen.dart'; // ✅ Add this import

class EmailVerificationWaitingScreen extends StatefulWidget {
  const EmailVerificationWaitingScreen({super.key});

  @override
  State<EmailVerificationWaitingScreen> createState() => _EmailVerificationWaitingScreenState();
}

class _EmailVerificationWaitingScreenState extends State<EmailVerificationWaitingScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _checking = false;

  Future<void> _checkEmailVerified() async {
    setState(() {
      _checking = true;
    });

    await _auth.currentUser?.reload();
    final user = _auth.currentUser;

    if (user != null && user.emailVerified) {
      // ✅ Only navigate to role selection
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email is not verified yet. Please check again.")),
      );
    }

    setState(() {
      _checking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDEDD2),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.mark_email_read_outlined, size: 100, color: Color(0xFF770A1D)),
              const SizedBox(height: 30),
              const Text(
                "Verify Your Email",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF770A1D)),
              ),
              const SizedBox(height: 20),
              const Text(
                "We've sent a verification link to your email address.\n\n"
                    " Please open your email inbox.\n"
                    " Click the verification link in the email.\n"
                    " Once you've verified it, come back here and tap the 'Verify' button below to continue.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Color(0xFF770A1D)),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _checking ? null : _checkEmailVerified,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFC77900),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                ),
                child: _checking
                    ? const CircularProgressIndicator(color: Colors.black)
                    : const Text("Verify", style: TextStyle(fontSize: 18, color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
