import 'package:education_app/res/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../res/components/custom_button.dart';
import '../../../utils/routes/route_name.dart';
import '../../splash/view_model/navigation_view_model.dart';
import '../view_model/question_view_model.dart';

class ScoreView extends StatefulWidget {
  const ScoreView({super.key});

  @override
  State<ScoreView> createState() => _ScoreViewState();
}

class _ScoreViewState extends State<ScoreView> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuestionViewModel>();
    final totalQuestions = provider.questions.length;
    final score = provider.score; // ✅ Now this works
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
                children: [
                  SizedBox(height: 80.h),
                  Center(
                    child: Image(
                      height: 100.h,
                      width: 100.w,
                      image: AssetImage('images/logo.png'),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Center(
                    child: Text(
                      'Result',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor.withOpacity(.2), // Very light orange
                      border: Border.all(
                        color: AppColors.primaryColor, // Dark orange border
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'You scored $score out of $totalQuestions',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                  CustomButton(
                    title: 'Go to Home',
                    onPressed: () {
                      context.read<QuestionViewModel>().reset();
                      context.read<NavigationViewModel>().setIndex(1);
                      Navigator.pushReplacementNamed(
                        context,
                        RouteName.mainWrapper, // clear previous stack
                      );
                    },
                  )

                ]
            ),
          )
      ),
    );
  }
}
