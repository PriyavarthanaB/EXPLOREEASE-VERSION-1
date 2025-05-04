import 'dart:async';
import 'package:flutter/material.dart';
import 'chat_screen.dart';

class CountdownToChatScreen extends StatefulWidget {
  final String bookingId;
  final String guideId;
  final String touristId;

  const CountdownToChatScreen({
    super.key,
    required this.bookingId,
    required this.guideId,
    required this.touristId,
  });

  @override
  State<CountdownToChatScreen> createState() => _CountdownToChatScreenState();
}

class _CountdownToChatScreenState extends State<CountdownToChatScreen> {
  int _secondsLeft = 5;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft == 0) {
        timer.cancel();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => ChatScreen(
              bookingId: widget.bookingId,
              guideId: widget.guideId,
              touristId: widget.touristId,
            ),
          ),
        );
      } else {
        setState(() {
          _secondsLeft--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Redirecting to chat...",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF770A1D),
              ),
            ),
            const SizedBox(height: 20),
            CircularProgressIndicator(
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF770A1D)),
            ),
            const SizedBox(height: 16),
            Text(
              'In $_secondsLeft seconds',
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
