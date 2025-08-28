import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../features/chat/view_model/chat_view_model.dart';
import '../app_colors.dart';

class BottomChatField extends StatefulWidget {
  const BottomChatField({super.key});

  @override
  State<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends State<BottomChatField> {
  bool isShowSendButton = false;
  final TextEditingController _messageController = TextEditingController();

  void sendTextMessage(ChatViewModel chatVM) {
    if (isShowSendButton) {
      chatVM.sendMessage(_messageController.text.trim());
      setState(() {
        _messageController.clear();
        isShowSendButton = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatVM = Provider.of<ChatViewModel>(context, listen: false);

    return Padding(
      padding: EdgeInsets.only(left: 8.w, right: 8.w, bottom: 8.h),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _messageController,
              onChanged: (val) {
                setState(() {
                  isShowSendButton = val.isNotEmpty;
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: const Icon(Icons.emoji_emotions, color: Colors.grey),
                ),
                suffixIcon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.camera_alt, color: Colors.grey),
                      SizedBox(width: 8.w),
                      const Icon(Icons.attach_file, color: Colors.grey),
                    ],
                  ),
                ),
                hintText: 'Type your message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.all(10.w),
              ),
            ),
          ),
          SizedBox(width: 6.w),
          CircleAvatar(
            radius: 24.r,
            backgroundColor: AppColors.primaryColor,
            child: GestureDetector(
              onTap: () => sendTextMessage(chatVM),
              child: Icon(
                isShowSendButton ? Icons.send : Icons.mic,
                color: AppColors.secondaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}