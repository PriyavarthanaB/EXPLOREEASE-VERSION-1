import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/guide_home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print("❌ Firebase Initialization Error: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final role = await _getUserRole(user.uid);
      if (role != null) {
        final userDoc = FirebaseFirestore.instance.collection(role).doc(user.uid);
        if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
          await userDoc.update({
            'isOnline': false,
            'lastSeen': Timestamp.now(),
          });
        } else if (state == AppLifecycleState.resumed) {
          await userDoc.update({
            'isOnline': true,
          });
        }
      }
    }
  }

  Future<String?> _getUserRole(String uid) async {
    try {
      final guideDoc = await FirebaseFirestore.instance.collection('guides').doc(uid).get();
      if (guideDoc.exists) return 'guides';

      final touristDoc = await FirebaseFirestore.instance.collection('tourists').doc(uid).get();
      if (touristDoc.exists) return 'tourists';

      return null; // If role not found
    } catch (e) {
      print("❌ Error fetching user role: $e");
      return null; // Return null in case of error
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Explore Ease',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (_) => StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasData) {
                    // User is logged in, now check their role using FutureBuilder
                    return FutureBuilder<String?>(
                      future: _getUserRole(snapshot.data!.uid),
                      builder: (context, roleSnapshot) {
                        if (roleSnapshot.connectionState == ConnectionState.waiting) {
                          return const Scaffold(
                            body: Center(child: CircularProgressIndicator()),
                          );
                        } else if (roleSnapshot.hasData) {
                          // Check the role and navigate to the appropriate screen
                          final role = roleSnapshot.data;
                          if (role == 'guides') {
                            return const GuideHomeScreen(); // Home for Guides
                          } else if (role == 'tourists') {
                            return const HomeScreen(); // Home for Tourists
                          } else {
                            return const LoginScreen(); // Role not found, go to login
                          }
                        } else {
                          return const LoginScreen(); // If roleSnapshot has no data, go to login
                        }
                      },
                    );
                  } else {
                    return const LoginScreen(); // User is not logged in, go to login
                  }
                },
              ),
            );
          case '/signup':
            return MaterialPageRoute(builder: (_) => const SignupScreen());
          default:
            return MaterialPageRoute(
              builder: (_) => const Scaffold(
                body: Center(
                  child: Text(
                    "404 - Page Not Found",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            );
        }
      },
    );
  }
}
