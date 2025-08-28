import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import '../../utils/routes/route_name.dart';

class SplashServices {
  Future<void> isLogin(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 5)); // smooth delay

    final user = FirebaseAuth.instance.currentUser;

    if (context.mounted) {
      if (user != null) {
        Navigator.pushReplacementNamed(context, RouteName.mainWrapper);
      } else {
        Navigator.pushReplacementNamed(context, RouteName.loginView);
      }
    }
  }
}