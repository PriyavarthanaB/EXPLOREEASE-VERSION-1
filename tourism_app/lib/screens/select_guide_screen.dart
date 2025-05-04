import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'booking_status_screen.dart';
import 'dart:async';

class SelectGuideScreen extends StatefulWidget {
  const SelectGuideScreen({super.key});

  @override
  State<SelectGuideScreen> createState() => _SelectGuideScreenState();
}

class _SelectGuideScreenState extends State<SelectGuideScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? touristName;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    fetchTouristName();
    testGuideFetch();
    _startSlotChecker();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> fetchTouristName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('tourists').doc(user.uid).get();
      final data = doc.data();
      if (data != null) {
        setState(() {
          touristName = data['username'] ?? 'Tourist';
        });
      }
    }
  }

  void testGuideFetch() async {
    var query = await _firestore
        .collection('guides')
        .where('isAvailable', isEqualTo: true)
        .get();

    for (var doc in query.docs) {
      print('Guide Found: ${doc.data()['username']}');
    }
  }

  void _startSlotChecker() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {}); // refreshes UI to re-check time slot matches
    });
  }

  bool _isNowInSlot(String slot) {
    final now = DateTime.now();
    final parts = slot.split(' to ');
    if (parts.length != 2) return false;

    try {
      final format = DateFormat('h:mm a');
      final startTimeRaw = format.parse(parts[0].trim());
      final endTimeRaw = format.parse(parts[1].trim());

      final startTime = DateTime(
        now.year,
        now.month,
        now.day,
        startTimeRaw.hour,
        startTimeRaw.minute,
      );
      DateTime endTime = DateTime(
        now.year,
        now.month,
        now.day,
        endTimeRaw.hour,
        endTimeRaw.minute,
      );

      if (endTime.isBefore(startTime)) {
        endTime = endTime.add(const Duration(days: 1));
      }

      return now.isAfter(startTime) && now.isBefore(endTime);
    } catch (e) {
      debugPrint('Slot parse error: $e');
      return false;
    }
  }

  Future<void> _handleBooking(String guideUid, String guideName) async {
    if (touristName == null) return;
    final user = FirebaseAuth.instance.currentUser!;

    final bookingRef = _firestore.collection('bookings').doc();
    final bookingData = {
      'touristId': user.uid,
      'guideId': guideUid,
      'touristName': touristName,
      'guideName': guideName,
      'status': 'pending',
      'timestamp': FieldValue.serverTimestamp(),
    };

    // 1) Create the booking document
    await bookingRef.set(bookingData);
    // 2) Mirror it under the guide’s subcollection
    await _firestore
        .collection('guides')
        .doc(guideUid)
        .collection('booking_requests')
        .doc(bookingRef.id)
        .set(bookingData);

    // ← NEW: mark the guide as unavailable so they vanish from other tourists’ lists
    await _firestore
        .collection('guides')
        .doc(guideUid)
        .update({'isAvailable': false});

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookingStatusScreen(bookingId: bookingRef.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Book Guide',
          style: TextStyle(
            color: Color(0xFF770A1D),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF770A1D)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Available Guides:',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF770A1D),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('guides')
                    .where('isAvailable', isEqualTo: true)
                    .orderBy('username')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data!.docs;
                  final matchingGuides = docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final slots = data['availability'] as List<dynamic>?;
                    if (slots == null) return false;
                    return slots.any((slot) => _isNowInSlot(slot.toString()));
                  }).toList();

                  if (matchingGuides.isEmpty) {
                    return const Center(
                      child: Text(
                          'No guides available for the current time slot.'),
                    );
                  }

                  return ListView.builder(
                    itemCount: matchingGuides.length,
                    itemBuilder: (context, index) {
                      final guideDoc = matchingGuides[index];
                      final data = guideDoc.data() as Map<String, dynamic>;
                      final name = data['username'] ?? 'Unknown';

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF770A1D),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const Icon(Icons.person,
                                      color: Colors.white),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          name,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('reviews')
                                              .where('guideId',
                                              isEqualTo: guideDoc.id)
                                              .snapshots(),
                                          builder: (context, snap2) {
                                            if (!snap2.hasData)
                                              return const SizedBox();
                                            final rvDocs = snap2.data!.docs;
                                            if (rvDocs.isEmpty) {
                                              return const Text(
                                                'No ratings yet',
                                                style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 12,
                                                ),
                                              );
                                            }
                                            double sum = 0;
                                            for (var d in rvDocs) {
                                              sum +=
                                                  (d['rating'] as num).toDouble();
                                            }
                                            final avg = (sum / rvDocs.length)
                                                .round();
                                            return Row(
                                              children: List.generate(5,
                                                      (i) {
                                                    return Icon(
                                                      i < avg
                                                          ? Icons.star
                                                          : Icons.star_border,
                                                      size: 16,
                                                      color: Colors.amber,
                                                    );
                                                  }),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () =>
                                  _handleBooking(guideDoc.id, name),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('Book'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
