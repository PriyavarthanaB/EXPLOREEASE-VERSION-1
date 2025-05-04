import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'count_down_to_chat_screen.dart'; // ✅ Make sure this is imported

class GuideRequestsScreen extends StatelessWidget {
  const GuideRequestsScreen({super.key});

  Future<void> _handleResponse(String bookingId, String status, String touristId) async {
    final firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser!;
    final guideId = user.uid;
    final chatId = '${guideId}_$touristId'; // ✅ Unique Chat ID

    await firestore.runTransaction((transaction) async {
      final bookingRef = firestore.collection('bookings').doc(bookingId);
      final bookingDoc = await transaction.get(bookingRef);

      if (!bookingDoc.exists) {
        throw Exception("Booking not found");
      }

      if (status == 'accepted') {
        final chatRef = firestore.collection('chats').doc(chatId);
        transaction.set(chatRef, {
          'chatId': chatId,
          'participants': [touristId, guideId],
          'createdAt': FieldValue.serverTimestamp(),
        });

        transaction.update(bookingRef, {
          'status': status,
          'respondedAt': FieldValue.serverTimestamp(),
          'chatId': chatId, // ✅ Save chatId in booking doc
        });
      } else {
        transaction.update(bookingRef, {
          'status': status,
          'respondedAt': FieldValue.serverTimestamp(),
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Pending Requests',
          style: TextStyle(
            color: Color(0xFF770A1D),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF770A1D)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('bookings')
              .where('guideId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .where('status', isEqualTo: 'pending')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  "No pending requests",
                  style: TextStyle(
                    color: Color(0xFF770A1D),
                    fontSize: 16,
                  ),
                ),
              );
            }

            final requests = snapshot.data!.docs;

            return ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index].data() as Map<String, dynamic>;
                final bookingId = requests[index].id;
                final touristName = request['touristName'] ?? 'Tourist';
                final touristId = request['touristId'];
                final timestamp = request['timestamp'] as Timestamp;
                final formattedTime = DateFormat('MMM dd, hh:mm a').format(timestamp.toDate());

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF770A1D),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              touristName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              formattedTime,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _handleResponse(bookingId, 'rejected', touristId);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text("Reject"),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () async {
                              try {
                                await _handleResponse(bookingId, 'accepted', touristId);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CountdownToChatScreen(
                                      bookingId: bookingId,
                                      guideId: FirebaseAuth.instance.currentUser!.uid,
                                      touristId: touristId,
                                    ),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error accepting request: $e')),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text("Accept"),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
