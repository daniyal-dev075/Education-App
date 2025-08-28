import 'package:education_app/res/app_colors.dart';
import 'package:education_app/res/components/main_wrapper.dart';
import 'package:education_app/utils/routes/routes.dart';
import 'package:education_app/utils/routes/route_name.dart';
import 'package:education_app/features/auth_and_profile/view_model/auth_view_model.dart';
import 'package:education_app/features/chat/view_model/chat_view_model.dart';
import 'package:education_app/features/auth_and_profile/view_model/image_view_model.dart';
import 'package:education_app/features/splash/view_model/navigation_view_model.dart';
import 'package:education_app/features/auth_and_profile/view_model/password_view_model.dart';
import 'package:education_app/features/quiz/view_model/question_view_model.dart';
import 'package:education_app/features/task/view_model/task_view_model.dart';
import 'package:education_app/features/auth_and_profile/view_model/user_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'data/firebase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // use only if using FlutterFire CLI
  );

  final currentUser = FirebaseAuth.instance.currentUser;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QuestionViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProxyProvider<UserViewModel, TaskViewModel?>(
          create: (_) => null,
          update: (context, userVM, previousTaskVM) {
            final uid = userVM.userData?['uid'];
            if (uid == null) return null;

            if (previousTaskVM == null || previousTaskVM.userId != uid) {
              // dispose old listener before switching user
              return TaskViewModel(userId: uid);
            }
            return previousTaskVM;
          },
        ),
        ChangeNotifierProvider(create: (_) => NavigationViewModel()),
        ChangeNotifierProvider(create: (_) => PasswordViewModel()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => ImageViewModel()),
        ChangeNotifierProvider(create: (_) => ChatViewModel())
      ],
      child: const MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(360, 800),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context,child){
          return MaterialApp(
            theme: ThemeData(
              textSelectionTheme: TextSelectionThemeData(
                cursorColor: AppColors.primaryColor,
                selectionHandleColor: AppColors.primaryColor
              )
            ),
            home: MainWrapper(),
            debugShowCheckedModeBanner: false,
            initialRoute: RouteName.splashView,
            onGenerateRoute: Routes.generateRoute,
          );
        }
    );
  }
}

