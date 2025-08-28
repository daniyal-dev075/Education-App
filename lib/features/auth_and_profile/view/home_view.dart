import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:education_app/res/components/loader.dart';
import 'package:education_app/features/auth_and_profile/view/profile_view.dart';
import 'package:education_app/features/quiz/view/quiz_home_view.dart';
import 'package:education_app/features/task/view/task_view.dart';
import 'package:education_app/features/splash/view_model/navigation_view_model.dart';
import 'package:education_app/features/quiz/view_model/question_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../chat/model/message_model.dart';
import '../../chat/view_model/chat_view_model.dart';
import '../../quiz/model/quiz_attempt_model.dart';
import '../../../res/app_colors.dart';
import '../../../utils/utils.dart';
import '../view_model/auth_view_model.dart';
import '../../task/view_model/task_view_model.dart';
import '../view_model/user_view_model.dart';
import '../../chat/view/chat_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final List<Widget> _pages = const [
    HomeView(),
    QuizHomeView(),
    ChatView(),
    TaskView(),
    ProfileView(),
  ];
  final List<String> cardNames = [
    "Home",
    "Quiz",
    "Chat",
    "Profile",
    "Settings",
  ];

  String _formatTime(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $period';
  }
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserViewModel>(context);
    final navigationProvider = Provider.of<NavigationViewModel>(context);
    final questionProvider = Provider.of<QuestionViewModel>(context);

    final userData = userProvider.userData;
    final name = userData?['name'] ?? "User";
    final profileImageUrl = userData?['profilePic'];
    final email = userData?['email'];
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          "StudySphere",
          style: TextStyle(
            color: AppColors.secondaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryColor, AppColors.secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),

                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 18,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: userProvider.isLoading
                  ? const Center(
                      child: SizedBox(height: 70, width: 100, child: Loader()),
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Profile Avatar
                        CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: profileImageUrl != null
                              ? NetworkImage(profileImageUrl)
                              : null,
                          child: profileImageUrl == null
                              ? const Icon(
                                  Icons.person,
                                  size: 40,
                                  color: Colors.grey,
                                )
                              : null,
                        ),

                        const SizedBox(width: 16),

                        // Greeting + Name
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: "Hello, ",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    TextSpan(
                                      text: name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.secondaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "$email",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.backgroundColor,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Logout button
                        Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.primaryColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: IconButton(
                            onPressed: () {
                              SystemNavigator.pop();
                            },
                            icon: const Icon(
                              Icons.exit_to_app_outlined,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
            SizedBox(height: 80.h),
            Center(
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 350,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                  viewportFraction: 0.85,
                ),
                items: [
                  Builder(
                    builder: (context) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.primaryColor,
                              AppColors.secondaryColor,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "📋 Tasks",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Expanded(
                                child: Consumer<TaskViewModel?>(
                                  builder: (context, taskVM, _) {
                                    // 👇 Handle null case (when user not logged in OR provider not ready yet)
                                    if (taskVM == null) {
                                      return const Center(
                                        child: Text(
                                          "No user logged in",
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 16,
                                          ),
                                        ),
                                      );
                                    }

                                    // 👇 Handle loading
                                    if (taskVM.isLoading) {
                                      return const Center(child: Loader());
                                    }

                                    // 👇 Handle empty list
                                    if (taskVM.tasks.isEmpty) {
                                      return const Center(
                                        child: Text(
                                          "No tasks yet. Add one!",
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 16,
                                          ),
                                        ),
                                      );
                                    }

                                    // 👇 Show tasks
                                    return ListView.builder(
                                      itemCount: taskVM.tasks.length,
                                      itemBuilder: (context, index) {
                                        final task = taskVM.tasks[index];

                                        return ListTile(
                                          title: Text(
                                            task.title,
                                            style: TextStyle(
                                              color: Colors.white,
                                              decoration: task.isCompleted
                                                  ? TextDecoration.lineThrough
                                                  : null,
                                            ),
                                          ),
                                          subtitle: task.details.trim().isNotEmpty
                                              ? Text(
                                            Utils.getPreviewText(task.details),
                                            style: TextStyle(color: AppColors.secondaryColor),
                                          )
                                              : null,
                                          trailing: IconButton(
                                            icon: const Icon(Icons.delete, color: Colors.white),
                                            onPressed: () {
                                              taskVM.deleteTask(task.id);
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
        Builder(
          builder: (context) {
            return StreamBuilder<List<QuizAttemptModel>>(
              stream: questionProvider.quizAttemptsStream(uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loader();
                }
                if (snapshot.hasError) {
                  return const Text("Error loading attempts");
                }

                final attempts = snapshot.data ?? [];

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.primaryColor,
                        AppColors.secondaryColor,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "🏆 Quiz Scores",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Expanded area for scores or message
                        Expanded(
                          child: attempts.isEmpty
                              ? const Center(
                            child: Text(
                              "No quiz attempts yet!",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white70,
                              ),
                            ),
                          )
                              : ListView.builder(
                            itemCount: attempts.length,
                            itemBuilder: (context, index) {
                              final attempt = attempts[index];
                              return ListTile(
                                leading: const Icon(
                                  Icons.star,
                                  color: Colors.white,
                                ),
                                title: Text(
                                  "Score: ${attempt.score}/${attempt.totalQuestions}",
                                  style: const TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  "Date: ${attempt.date.toLocal().toString().split(' ')[0]}",
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                trailing: Text(
                                  "${attempt.quizId}",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
        Builder(
                    builder: (context) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.primaryColor,
                              AppColors.secondaryColor,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0,horizontal: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "💬 Group Chat",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // 👇 Stream messages from Firestore
                              Expanded(
                                child: Consumer<ChatViewModel>(
                                  builder: (context, chatVM, _) {
                                    return StreamBuilder<List<MessageModel>>(
                                      stream: chatVM.getGroupMessages(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return const Center(child: Loader());
                                        }
                                        if (snapshot.hasError) {
                                          return const Center(
                                            child: Text(
                                              "Error loading messages",
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          );
                                        }
                                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                          return const Center(
                                            child: Text(
                                              "No messages yet!",
                                              style: TextStyle(color: Colors.white70),
                                            ),
                                          );
                                        }

                                        final messages = snapshot.data!;

                                        return ListView.builder(
                                          itemCount: messages.length,
                                          itemBuilder: (context, index) {
                                            final msg = messages[index];
                                            return ListTile(
                                              title: Text(
                                                msg.senderName ?? "Unknown",
                                                style: const TextStyle(color: Colors.white),
                                              ),
                                              subtitle: Text(
                                                msg.text,
                                                style: const TextStyle(color: Colors.white70),
                                              ),
                                              trailing: Text(
                                                _formatTime(msg.timeSent), // format to "2:30 PM"
                                                style: const TextStyle(
                                                  color: Colors.white60,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
