import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'count_down_to_chat_screen.dart';  // Import the CountDownToChatScreen

class BookingStatusScreen extends StatefulWidget {
  final String bookingId;

  const BookingStatusScreen({super.key, required this.bookingId});

  @override
  State<BookingStatusScreen> createState() => _BookingStatusScreenState();
}

class _BookingStatusScreenState extends State<BookingStatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDEDDC), // Full beige background
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('bookings')
              .doc(widget.bookingId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text('Booking not found.'));
            }

            final data = snapshot.data!.data() as Map<String, dynamic>;
            final status = data['status'] ?? 'pending';
            final chatId = data['chatId'];
            final guideId = data['guideId'];
            final touristId = data['touristId'];

            IconData icon;
            Color color;
            String message;

            if (status == 'accepted') {
              icon = Icons.check_circle;
              color = Colors.green;
              message = 'Your booking was accepted!';
              if (chatId != null) {
                Future.delayed(const Duration(milliseconds: 500), () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => CountdownToChatScreen(
                        bookingId: widget.bookingId,
                        guideId: guideId,
                        touristId: touristId,
                      ),
                    ),
                  );
                });
              }
            } else if (status == 'rejected') {
              icon = Icons.cancel;
              color = Colors.red;
              message = 'Your booking was rejected.';
            } else {
              icon = Icons.hourglass_top;
              color = const Color(0xFF770A1D);
              message = 'Waiting for guide to respond...';
            }

            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 80, color: color),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    style: TextStyle(fontSize: 20, color: color),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF770A1D),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Back'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
