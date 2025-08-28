import 'package:education_app/res/components/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app_colors.dart';


class CustomButton extends StatefulWidget {
  final String title;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final double borderRadius;
  final Color? color;
  final TextStyle? textStyle;
  final bool isLoading;

  const CustomButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.width,
    this.height = 50,
    this.borderRadius = 10,
    this.color,
    this.textStyle,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height?.h,
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.color ?? AppColors.primaryColor,
          disabledBackgroundColor: Colors.grey[400],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius.r),
          ),
          elevation: 3,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
        ),
        child: widget.isLoading
            ? SizedBox(
          child: const Loader()
        )
            : Text(
          widget.title,
          style: widget.textStyle ??
              TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}
