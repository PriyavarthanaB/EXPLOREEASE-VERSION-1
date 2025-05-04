import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_profile_screen.dart';
import 'review_page.dart';

class ChatScreen extends StatefulWidget {
  final String bookingId;
  final String guideId;
  final String touristId;

  const ChatScreen({
    super.key,
    required this.bookingId,
    required this.guideId,
    required this.touristId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String otherUserName = '';
  String otherUserProfileUrl = '';
  String otherUserId = '';
  bool isGuide = false;
  bool isTyping = false;
  bool otherUserTyping = false;
  String currentUserId = '';
  bool _hasEnded = false;

  @override
  void initState() {
    super.initState();
    currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    isGuide = currentUserId == widget.guideId;
    otherUserId = isGuide ? widget.touristId : widget.guideId;
    _fetchOtherUserDetails();
    _listenTypingStatus();
    _listenEndChat();
  }

  void _fetchOtherUserDetails() async {
    final role = isGuide ? 'tourists' : 'guides';
    final doc = await FirebaseFirestore.instance.collection(role).doc(otherUserId).get();
    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        otherUserName = data['username'] ?? 'User';
        otherUserProfileUrl = data['profileUrl'] ?? '';
      });
    }
  }

  void _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    await FirebaseFirestore.instance.collection('chats/${widget.bookingId}/messages').add({
      'text': message,
      'senderId': currentUserId,
      'timestamp': FieldValue.serverTimestamp(),
      'seenBy': [currentUserId],
    });

    _messageController.clear();
    _setTyping(false);
    Future.delayed(const Duration(milliseconds: 300), _scrollToBottom);
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  String _formatTime(Timestamp timestamp) {
    DateTime time = timestamp.toDate();
    return DateFormat('hh:mm a').format(time);
  }

  void _openUserProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UserProfileScreen(
          userId: otherUserId,
          role: isGuide ? 'tourists' : 'guides',
        ),
      ),
    );
  }

  void _setTyping(bool typing) async {
    if (typing == isTyping) return;
    setState(() {
      isTyping = typing;
    });
    await FirebaseFirestore.instance.collection('chats').doc(widget.bookingId).set({
      isGuide ? 'guideTyping' : 'touristTyping': typing,
    }, SetOptions(merge: true));
  }

  void _listenTypingStatus() {
    FirebaseFirestore.instance.collection('chats').doc(widget.bookingId).snapshots().listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data()!;
        setState(() {
          otherUserTyping = data[isGuide ? 'touristTyping' : 'guideTyping'] ?? false;
        });
      }
    });
  }

  void _markMessageSeen(DocumentSnapshot message) async {
    final seenBy = List<String>.from(message['seenBy'] ?? []);
    if (!seenBy.contains(currentUserId)) {
      await message.reference.update({
        'seenBy': FieldValue.arrayUnion([currentUserId]),
      });
    }
  }

  void _endChat() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('End Chat'),
        content: const Text('Are you sure you want to end the session?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Yes')),
        ],
      ),
    );
    if (confirm != true) return;

    await FirebaseFirestore.instance.collection('chats').doc(widget.bookingId).set({
      'endChat': true,
      'endedBy': currentUserId,
    }, SetOptions(merge: true));
  }

  void _listenEndChat() {
    FirebaseFirestore.instance.collection('chats').doc(widget.bookingId).snapshots().listen((snapshot) async {
      if (!snapshot.exists) return;
      final data = snapshot.data()!;
      if (data['endChat'] == true && !_hasEnded) {
        _hasEnded = true;
        final endedBy = data['endedBy'] as String?;

        if (endedBy != currentUserId) {
          final msg = endedBy == widget.touristId ? 'Tourist ended your session' : 'Guide ended your session';
          await showDialog(
            context: context,
            builder: (_) => AlertDialog(
              content: Text(msg),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
              ],
            ),
          );
        }

        if (currentUserId == widget.touristId) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => ReviewPage(guideId: widget.guideId)),
          );
        } else if (currentUserId == widget.guideId) {
          Navigator.pop(context);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDEDD2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF770A1D),
        titleSpacing: 0,
        title: Row(
          children: [
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _openUserProfile,
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                backgroundImage: otherUserProfileUrl.isNotEmpty ? NetworkImage(otherUserProfileUrl) : null,
                child: otherUserProfileUrl.isEmpty ? const Icon(Icons.person, color: Color(0xFF770A1D)) : null,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                otherUserName,
                style: const TextStyle(fontSize: 18, color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats/${widget.bookingId}/messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data!.docs;
                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final fromMe = msg['senderId'] == currentUserId;
                    _markMessageSeen(msg);
                    return Align(
                      alignment: fromMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF770A1D),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              msg['text'],
                              style: const TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            if (msg['timestamp'] != null)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _formatTime(msg['timestamp']),
                                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          if (otherUserTyping)
            const Padding(
              padding: EdgeInsets.only(left: 16, bottom: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Typing...', style: TextStyle(color: Colors.black54)),
              ),
            ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    onChanged: (text) => _setTyping(text.isNotEmpty),
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send, color: Color(0xFF770A1D)),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(const Color(0xFF770A1D)),
            ),
            onPressed: _endChat,
            child: const Text('End Chat', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
