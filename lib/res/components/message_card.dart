import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../app_colors.dart';

class MessageCard extends StatelessWidget {
  final String message;
  final String time;
  final String senderId;
  final String senderName;
  final String currentUserId;

  const MessageCard({
    super.key,
    required this.message,
    required this.time,
    required this.senderId,
    required this.senderName,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    bool isMe = senderId == currentUserId;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          color: isMe ? AppColors.primaryColor : AppColors.secondaryColor,
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 10,
                  right: 30,
                  top: 5, // extra space for sender name
                  bottom: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isMe)
                      Text(
                        senderName,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    Text(
                      message,
                      style: TextStyle(fontSize: 16.sp,color: Colors.white),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Text(
                  time,
                  style: TextStyle(fontSize: 13.sp, color: Colors.white60),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
