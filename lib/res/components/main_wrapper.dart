import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:education_app/features/splash/view_model/navigation_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/chat/view/chat_view.dart';
import '../../features/auth_and_profile/view/home_view.dart';
import '../../features/auth_and_profile/view/profile_view.dart';
import '../../features/quiz/view/quiz_home_view.dart';
import '../../features/task/view/task_view.dart';
import '../app_colors.dart';

class MainWrapper extends StatelessWidget {
  const MainWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationViewModel>(context);

    final List<Widget> _pages = const [
      HomeView(),     // Home screen
      QuizHomeView(), // Quiz screen
      ChatView(),     // Chat screen
      TaskView(),     // Task screen
      ProfileView(),  // Profile screen
    ];

    return Scaffold(
      body: _pages[navigationProvider.currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: AppColors.primaryColor,
        height: 60,
        index: navigationProvider.currentIndex,
        onTap: (index) {
          navigationProvider.setIndex(index);
        },
        items: const [
          Icon(Icons.home, color: Colors.white),
          Icon(Icons.quiz, color: Colors.white),
          Icon(Icons.chat, color: Colors.white),
          Icon(Icons.task, color: Colors.white),
          Icon(Icons.person, color: Colors.white),
        ],
      ),
    );
  }
}
