import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:provider/provider.dart';
import '../../../res/app_colors.dart';
import '../../../utils/routes/route_name.dart';
import '../../auth_and_profile/view_model/user_view_model.dart';

class QuizHomeView extends StatefulWidget {
  const QuizHomeView({super.key});

  Widget _instructionItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('✓ ', style: TextStyle(fontSize: 18.sp, color: Colors.green, fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 18.sp),
            ),
          ),
        ],
      ),
    );
  }
  @override
  State<QuizHomeView> createState() => _QuizHomeViewState();
}

class _QuizHomeViewState extends State<QuizHomeView> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    Provider.of<UserViewModel>(context, listen: false).fetchUserData();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "Quiz",
            style: TextStyle(
              color: AppColors.secondaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColors.primaryColor,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              children: [
                SizedBox(height: 10.h),
                Center(
                  child: Image(
                    height: 100.h,
                    width: 100.w,
                    image: AssetImage('images/logo.png'),
                  ),
                ),
                Center(
                  child: Text(
                    'Instructions',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor.withOpacity(.2), // light orange background
                    border: Border.all(color: AppColors.primaryColor,width: 2), // dark border
                    borderRadius: BorderRadius.circular(12), // rounded corners (optional)
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // align text to the left
                    children: [
                      widget._instructionItem('This quiz contains 10 questions.'),
                      widget._instructionItem('Each question carries 1 mark.'),
                      widget._instructionItem('You will get 15 seconds to answer each question.'),
                      widget._instructionItem('Only one option is correct for each question.'),
                      widget._instructionItem('After 15 seconds, the question will be skipped automatically.'),
                      widget._instructionItem('Try to score as much as you can!'),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  height: 56,
                  width: double.infinity,
                  child: SwipeButton.expand(
                    thumb: Icon(Icons.arrow_forward_outlined, color: Colors.white, size: 24),
                    activeThumbColor: AppColors.primaryColor,
                    activeTrackColor: Colors.grey.shade300,
                    child: Text(
                      'Swipe to Start Quiz',
                      style: TextStyle(color: AppColors.primaryColor, fontSize: 18,fontWeight: FontWeight.bold),
                    ),
                    onSwipe: () => Navigator.pushNamed(context, RouteName.quizView),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
