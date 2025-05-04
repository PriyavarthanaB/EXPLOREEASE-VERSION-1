import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';

class ReviewPage extends StatefulWidget {
  final String guideId;  // Add guideId as a parameter

  const ReviewPage({super.key, required this.guideId});  // Update constructor to accept guideId

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  int _rating = 0;
  final TextEditingController _reviewController = TextEditingController();
  bool _isSubmitting = false;

  // Function to build stars for rating
  Widget _buildStar(int index) {
    final isFilled = index < _rating;
    return IconButton(
      icon: Icon(
        isFilled ? Icons.star : Icons.star_border,
        size: 32,
        color: Colors.amber,
      ),
      onPressed: () => setState(() => _rating = index + 1),
    );
  }

  // Function to submit the review to Firestore
  Future<void> _submitReview() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a star rating.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // Add review to Firestore
      await FirebaseFirestore.instance.collection('reviews').add({
        'userId': user.uid,
        'guideId': widget.guideId,  // Store guideId in the review collection
        'rating': _rating,
        'reviewText': _reviewController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review submitted!')),
      );

      // Navigate back to the home screen after submission
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
            (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting review: $e')),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  // Cancel the review process and navigate back to home screen
  void _cancelReview() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDEDD2), // Beige background
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDEDD2),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Leave a Review',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'How was your experience?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Rating stars
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF770A1D),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) => _buildStar(i)),
              ),
            ),
            const SizedBox(height: 20),
            // Review text input field
            Expanded(
              child: TextField(
                controller: _reviewController,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  hintText: 'Write your review...',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Buttons for canceling or submitting the review
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isSubmitting ? null : _cancelReview,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: const Color(0xFFC77900),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitReview,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC77900),
                      foregroundColor: Colors.white, // ensure white text
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Submit'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
