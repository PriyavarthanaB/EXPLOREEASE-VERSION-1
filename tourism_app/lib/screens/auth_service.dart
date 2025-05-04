import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
// Google Sign-In Method
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User canceled sign-in
      final GoogleSignInAuthentication googleAuth = await
      googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential = await
      _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print("Error signing in with Google: $e");
      return null;
    }
  }
// Store user data in Firebase Realtime Database
  Future<void> storeUserData(String username, String language, String country,
      String email, String role) async {
    try {
// Get the currently logged-in user
      User? user = _auth.currentUser;
      if (user != null) {
        DatabaseReference ref =
        FirebaseDatabase.instance.ref("users/${user.uid}");
// Store user data
        await ref.set({
          "username": username,
          "language": language,
          "country": country,
          "email": email,
          "role": role, // 'Tourist' or 'Guide'
        });
        print("User data stored successfully!");
      }
    } catch (e) {
      print("Error storing user data: $e");
    }
  }
// Sign Out Method
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}