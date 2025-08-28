import 'package:education_app/res/components/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../res/app_colors.dart';
import '../../../res/components/custom_button.dart';
import '../../../res/components/time_bar.dart';
import '../../../utils/routes/route_name.dart';
import '../../splash/view_model/navigation_view_model.dart';
import '../view_model/question_view_model.dart';


class QuizView extends StatefulWidget {
  const QuizView({super.key});

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<QuestionViewModel>(context, listen: false).fetchQuestions(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.primaryColor,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: InkWell(
                  onTap: (){
                    context.read<QuestionViewModel>().reset();
                    Navigator.pushNamed(context, RouteName.quizHomeView);
                    context.read<NavigationViewModel>().setIndex(1);
                    Navigator.pushReplacementNamed(
                      context,
                      RouteName.mainWrapper, // clear previous stack
                    );
                  },
                  child: Text('Leave Quiz',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18.sp),)),
            ),
          ],
        ),
        body: Consumer<QuestionViewModel>(
          builder: (context, provider, _) {
            if (provider.questions.isEmpty) {
              return const Center(child: Loader());
            }

            final question = provider.questions[provider.currentIndex];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h,),
                  TimeBar(
                    key: ValueKey(provider.currentIndex),
                    totalSeconds: 15, // Set your quiz timer per question
                    onTimerComplete: () {
                      final provider = context.read<QuestionViewModel>();
                      provider.handleTimeUp(context); // Implement this function in your ViewModel
                    },
                  ),
                  SizedBox(height: 10.h,),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor.withOpacity(.25), // Very light orange
                      border: Border.all(
                        color: AppColors.primaryColor, // Dark orange border
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Q${question.questionNumber}: ${question.question}',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        ...question.options.map(
                              (option) => RadioListTile(
                            title: Text(option),
                            value: option,
                            groupValue: provider.selectedOption,
                            onChanged: (value) => provider.selectOption(value!),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (provider.answerFeedback != null) ...[
                    SizedBox(height: 20.h),
                    if (provider.isTimeUp)
                      Text(
                        provider.answerFeedback!, // ⏰ Time is up!
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                        ),
                      )
                    else if (provider.isAnswerCorrect == true)
                      Text(
                        provider.answerFeedback!,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.green[800],
                        ),
                      )
                    else
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            TextSpan(
                              text: '❌ Sorry, you are wrong.\n',
                              style: TextStyle(color: Colors.red[800]),
                            ),
                            TextSpan(
                              text: 'Correct Answer: ',
                              style: TextStyle(color: Colors.black),
                            ),
                            TextSpan(
                              text: provider.questions[provider.currentIndex].answer,
                              style: TextStyle(color: Colors.green[800]),
                            ),
                          ],
                        ),
                      ),
                  ],
                  SizedBox(height: 40.h),
                  if (provider.currentIndex == provider.questions.length - 1) ...[
                    CustomButton(
                      title: 'Finish',
                      onPressed: provider.selectedOption != null
                          ? () => provider.nextQuestion(context) // ✅ will trigger last-question logic
                          : null,
                    ),
                  ] else ...[
                    // Not last question: show Skip and Next
                    CustomButton(
                      title: 'Skip',
                      onPressed: () => provider.nextQuestion(context),
                    ),
                    SizedBox(height: 20.h),
                    CustomButton(
                      title: 'Next',
                      onPressed: provider.selectedOption != null
                          ? () => provider.nextQuestion(context)
                          : null,
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
