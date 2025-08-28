import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:education_app/res/app_colors.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Shimmer.fromColors(
          baseColor: AppColors.secondaryColor,
          highlightColor: AppColors.primaryColor,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 8.w, height: 8.h, decoration: BoxDecoration(color: Colors.grey, shape: BoxShape.circle)),
              SizedBox(width: 2.w),
              Container(width: 8.w, height: 8.h, decoration: BoxDecoration(color: Colors.grey, shape: BoxShape.circle)),
              SizedBox(width: 2.w),
              Container(width: 8.w, height: 8.h, decoration: BoxDecoration(color: Colors.grey, shape: BoxShape.circle)),
              SizedBox(width: 2.w),
              Container(width: 8.w, height: 8.h , decoration: BoxDecoration(color: Colors.grey, shape: BoxShape.circle)),
            ],
          ),
        )
    );
  }
}
