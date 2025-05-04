import 'package:flutter/material.dart';
import 'package:tourism_app/screens/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'auth_service.dart';
import 'home_screen.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';
import 'home_screen.dart';
import 'guide_availability_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService _authService = AuthService();
  bool _isPasswordVisible = false;

  Future<void> _signInWithEmailAndPassword() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = userCredential.user;

      if (user != null && !user.emailVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please verify your email before signing in.")),
        );
        return;
      }

      if (user != null) {
        await _updateOnlineStatus(true); // ✅ Set user as online
        await saveFcmToken(user.uid); // ✅ Save token after login
        await _navigateBasedOnRole(user.uid); // ✅ Navigate based on role
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid email or password")),
      );
    }
  }

  Future<void> saveFcmToken(String uid) async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'fcmToken': token,
      }, SetOptions(merge: true));
    }
  }

  Future<void> _navigateBasedOnRole(String uid) async {
    final touristDoc = await FirebaseFirestore.instance.collection('tourists').doc(uid).get();
    final guideDoc = await FirebaseFirestore.instance.collection('guides').doc(uid).get();

    if (touristDoc.exists) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else if (guideDoc.exists) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => GuideAvailabilityScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User role not found. Please contact support.")),
      );
    }
  }

  /// ✅ Update Online Status
  Future<void> _updateOnlineStatus(bool isOnline) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final role = await _getUserRole(user.uid); // 'guides' or 'tourists'
      await FirebaseFirestore.instance.collection(role).doc(user.uid).update({
        'isOnline': isOnline,
        if (!isOnline) 'lastSeen': Timestamp.now(),
      });
    }
  }

  /// ✅ Get User Role
  Future<String> _getUserRole(String uid) async {
    final guideDoc = await FirebaseFirestore.instance.collection('guides').doc(uid).get();
    return guideDoc.exists ? 'guides' : 'tourists';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.emailVerified) {
            _navigateBasedOnRole(snapshot.data!.uid);
            return const Center(child: CircularProgressIndicator());
          } else {
            return _buildLoginUI();
          }
        },
      ),
    );
  }

  Widget _buildLoginUI() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFDEDD2),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "EXPLORE EASE",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF770A1D),
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Color(0xFF770A1D),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _passwordController,
                  style: const TextStyle(color: Colors.white),
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Color(0xFF770A1D),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _signInWithEmailAndPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFC77900),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                    );
                  },
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(color: Color(0xFF770A1D)),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignupScreen()),
                    );
                  },
                  child: const Text(
                    "Don't have an account? Sign up",
                    style: TextStyle(color: Color(0xFF770A1D)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
