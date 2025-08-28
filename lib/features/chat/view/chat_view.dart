import 'package:education_app/res/components/loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../model/message_model.dart';
import '../../../res/app_colors.dart';
import '../../../res/components/bottom_chat_field.dart';
import '../view_model/chat_view_model.dart'; // NOTE: singular "view_model" as in your BottomChatField import
import '../../../res/components/message_card.dart'; // your MessageCard file

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  String _formatTime(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $period';
  }

  @override
  Widget build(BuildContext context) {
    final chatVM = Provider.of<ChatViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          "Group Chat",
          style: TextStyle(
            color: AppColors.secondaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          /// Messages List
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: chatVM.getGroupMessages(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Loader());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No messages yet"));
                }

                final messages = snapshot.data!;

                return ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    return MessageCard(
                      message: msg.text,
                      time: _formatTime(msg.timeSent), // convert DateTime -> string
                      senderId: msg.senderId,
                      senderName: msg.senderName,
                      currentUserId: chatVM.currentUserId,
                    );
                  },
                );
              },
            ),
          ),

          /// Bottom input
          const BottomChatField(),
        ],
      ),
    );
  }
}
