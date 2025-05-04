import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewRatingScreen extends StatelessWidget {
  final String guideId;
  const ViewRatingScreen({Key? key, required this.guideId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Color(0xFF770A1D)),
        title: Text('View Rating', style: TextStyle(color: Color(0xFF770A1D))),
        backgroundColor: Color(0xFFFDEDD2),
        elevation: 0,
      ),
      backgroundColor: Color(0xFFFDEDD2),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('reviews')
            .where('guideId', isEqualTo: guideId)
            .snapshots(),
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snap.hasData || snap.data!.docs.isEmpty) {
            return Center(child: Text('No reviews yet.'));
          }
          final reviews = snap.data!.docs;
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: reviews.length,
            itemBuilder: (ctx, i) => ReviewCard(reviewDoc: reviews[i]),
          );
        },
      ),
    );
  }
}

class ReviewCard extends StatefulWidget {
  final QueryDocumentSnapshot reviewDoc;
  const ReviewCard({Key? key, required this.reviewDoc}) : super(key: key);

  @override
  _ReviewCardState createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final data = widget.reviewDoc.data() as Map<String, dynamic>;
    // ← changed here: use 'userId', not 'touristId'
    final touristId = data['userId']?.toString() ?? '';
    final rating = (data['rating'] as num?)?.toInt() ?? 0;
    final text = data['reviewText']?.toString() ?? '';

    return FutureBuilder<DocumentSnapshot?>(
      future: touristId.isNotEmpty
          ? FirebaseFirestore.instance
          .collection('tourists')
          .doc(touristId)
          .get()
          : Future.value(null),
      builder: (ctx, snap) {
        String touristName;

        if (snap.connectionState == ConnectionState.waiting) {
          touristName = '';
        } else if (snap.hasError || snap.data == null || !snap.data!.exists) {
          touristName = touristId; // fallback to UID if something’s wrong
        } else {
          final td = snap.data!.data() as Map<String, dynamic>;
          touristName = td['username']?.toString() ?? touristId;
        }

        return Card(
          color: Color(0xFF770A1D),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon + username (pulled from 'username')
                Row(
                  children: [
                    Icon(Icons.person,
                        color: Colors.white),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        touristName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                // Star rating
                Row(
                  children: List.generate(5, (idx) {
                    return Icon(
                      idx < rating ? Icons.star : Icons.star_border,
                      size: 20,
                      color: Colors.yellowAccent,
                    );
                  }),
                ),
                SizedBox(height: 8),
                // Review text + toggle
                Text(
                  text,
                  style: TextStyle(color: Colors.white),
                  maxLines: _expanded ? null : 2,
                  overflow: _expanded
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                ),
                if (text.length > 100)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () =>
                          setState(() => _expanded = !_expanded),
                      child: Text(
                        _expanded ? 'See less' : 'See more',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
