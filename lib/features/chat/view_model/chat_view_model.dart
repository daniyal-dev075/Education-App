import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
 // keep the correct path
import '../model/message_model.dart';
import '../../../utils/enums/message_enum.dart';

class ChatViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get currentUserId => _auth.currentUser?.uid ?? '';

  String _currentUserName = 'User';
  String get currentUserName => _currentUserName;

  ChatViewModel() {
    _loadCurrentUserName();
  }

  Future<void> _loadCurrentUserName() async {
    try {
      final uid = currentUserId;
      if (uid.isEmpty) return;

      final doc = await _firestore.collection('users').doc(uid).get();
      _currentUserName =
          (doc.data()?['name'] as String?) ?? (_auth.currentUser?.displayName ?? 'User');
      notifyListeners();
    } catch (_) {
      // keep default if fails
    }
  }

  /// Stream of group messages (newest first)
  Stream<List<MessageModel>> getGroupMessages() {
    return _firestore
        .collection('groupChat')
        .orderBy('timeSent', descending: false)
        .snapshots()
        .map((snap) => snap.docs
        .map((d) => MessageModel.fromMap(d.data()))
        .toList());
  }

  /// Called by BottomChatField
  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || currentUserId.isEmpty) return;

    final docRef = _firestore.collection('groupChat').doc();
    final now = DateTime.now();

    final userDoc = await _firestore.collection('users').doc(currentUserId).get();
    final senderName = userDoc['name'] ?? 'User';

    final message = MessageModel(
      senderId: currentUserId,
      senderName: senderName,
      text: trimmed,
      type: MessageEnum.text, // 👈 MUST add type
      timeSent: now,
      messageId: docRef.id,
    );

    await docRef.set(message.toMap());
  }
}
