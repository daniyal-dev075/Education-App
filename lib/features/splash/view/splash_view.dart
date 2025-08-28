import 'package:animate_do/animate_do.dart';
import 'package:education_app/res/app_colors.dart';
import 'package:flutter/material.dart';

import '../splash_services.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  SplashServices splashServices = SplashServices();

  bool showLogo = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      splashServices.isLogin(context);
    });
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          showLogo = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 170,
                width: 170,
                child: showLogo
                    ? SlideInUp(
                  duration: const Duration(milliseconds: 2500),
                  child: Image.asset(
                    'images/logo.png',
                    height: 200,
                    width: 200,
                  ),
                )
                    : const SizedBox.shrink(), // Empty space before logo appears
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SlideInLeft(
                    duration: const Duration(milliseconds: 1000),
                    child: Text(
                      "Study",
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SlideInRight(
                    duration: const Duration(milliseconds: 1000),
                    child: const Text(
                      "Sphere",
                      style: TextStyle(
                        color: AppColors.secondaryColor,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        ),
      ),
    );

  }
}
