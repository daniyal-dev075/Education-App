import 'package:education_app/res/components/main_wrapper.dart';
import 'package:education_app/utils/routes/route_name.dart';
import 'package:education_app/features/chat/view/chat_view.dart';
import 'package:education_app/features/auth_and_profile/view/profile_view.dart';
import 'package:education_app/features/quiz/view/quiz_home_view.dart';
import 'package:education_app/features/quiz/view/quiz_view.dart';
import 'package:education_app/features/quiz/view/score_view.dart';
import 'package:education_app/features/auth_and_profile/view/signup_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../features/auth_and_profile/view/home_view.dart';
import '../../features/auth_and_profile/view/login_view.dart';
import '../../features/splash/view/splash_view.dart';
import '../../features/task/view/task_view.dart';



class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.splashView:
        return MaterialPageRoute(
          builder: (BuildContext context) => SplashView(),
        );
      case RouteName.loginView:
        return MaterialPageRoute(
          builder: (BuildContext context) => LoginView(),
        );
      case RouteName.homeView:
        return MaterialPageRoute(
          builder: (BuildContext context) => HomeView(),
        );
      case RouteName.signupView:
        return MaterialPageRoute(
          builder: (BuildContext context) => SignupView(),
        );
      case RouteName.quizHomeView:
        return MaterialPageRoute(
          builder: (BuildContext context) => QuizHomeView(),
        );
      case RouteName.chatView:
        return MaterialPageRoute(
          builder: (BuildContext context) => ChatView(),
        );
      case RouteName.taskView:
        return MaterialPageRoute(
          builder: (BuildContext context) => TaskView(),
        );
      case RouteName.profileView:
        return MaterialPageRoute(
          builder: (BuildContext context) => ProfileView(),
        );
      case RouteName.mainWrapper:
        return MaterialPageRoute(
          builder: (BuildContext context) => MainWrapper(),
        );
      case RouteName.quizView:
        return MaterialPageRoute(
          builder: (BuildContext context) => QuizView(),
        );
      case RouteName.scoreView:
        return MaterialPageRoute(
          builder: (BuildContext context) => ScoreView(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) {
            return Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Center(child: Text('No Route Found'))],
              ),
            );
          },
        );
    }
  }
}
