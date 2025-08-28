import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../utils/enums/message_enum.dart';

class MessageModel {
  final String senderId;
  final String senderName;
  final String text;
  final MessageEnum type;
  final DateTime timeSent;
  final String messageId;

  MessageModel({
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.type,
    required this.timeSent,
    required this.messageId,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderName': senderName,
      'text': text,
      'type': type.type,
      'timeSent': timeSent,
      'messageId': messageId,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      senderId: map['senderId'],
      senderName: map['senderName'],
      text: map['text'],
      type: (map['type'] as String).toEnum(),
      timeSent: (map['timeSent'] as Timestamp).toDate(),
      messageId: map['messageId'],
    );
  }
}
