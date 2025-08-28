import 'package:education_app/res/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  void toastMessage(String message){
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppColors.secondaryColor,
        timeInSecForIosWeb: 2,
        fontSize: 16.sp
    );
  }
  static String getPreviewText(String details) {
    final words = details.trim().split(RegExp(r'\s+'));
    if (words.length <= 3) {
      return words.join(' ');
    } else {
      return '${words.take(3).join(' ')}...';
    }
  }
}