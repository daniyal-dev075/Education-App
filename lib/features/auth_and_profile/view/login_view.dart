import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:education_app/res/app_colors.dart';

import '../../../res/components/custom_button.dart';
import '../../../res/components/custom_text_form_field.dart';
import '../../../res/components/forgot_password_bottom_sheet.dart';
import '../../../utils/routes/route_name.dart';
import '../view_model/auth_view_model.dart';
import '../view_model/password_view_model.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    final passwordViewModel = Provider.of<PasswordViewModel>(context);
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop(); // This will close the app
        return false; // Prevent default// back navigation
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.backgroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              children: [
                SizedBox(height: 80.h),
                Center(
                  child: Image(
                    height: 120.h,
                    width: 120.w,
                    image: AssetImage('images/logo.png'),
                  ),
                ),
                SizedBox(height: 20.h),
                Center(
                  child: Text(
                    'Welcome Back',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Email',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
                SizedBox(height: 2.h,),
                CustomTextFormField(
                  controller: emailController,
                  hintText: 'Enter your email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                SizedBox(height: 20.h),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Password',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
                SizedBox(height: 2.h,),
                CustomTextFormField(
                  controller: passwordController,
                  hintText: 'Enter your Password',
                  prefixIcon: Icon(Icons.lock_open),
                  isPassword: true,
                  obscureText: passwordViewModel.obscureText,
                  onToggleVisibility: passwordViewModel.toggleVisibility,
                ),
                SizedBox(height: 4.h),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                      ),
                      builder: (context) => const ForgotPasswordBottomSheet(),
                    );
                  },
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 80.h),
                Consumer<AuthViewModel>(
                  builder: (context, provider, _) {
                    return CustomButton(
                      title: 'Log In',
                      isLoading: provider.isLoading,
                      onPressed: () {
                        provider.login(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                          context: context,
                        );
                      },
                    );
                  },
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an Account?',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.sp
                      ),
                    ),
                    SizedBox(width: 2.h,),
                    InkWell(
                        onTap: (){
                          Navigator.pushNamed(context, RouteName.signupView);
                        },
                        child: Text('Sign Up',style: TextStyle(color: AppColors.primaryColor,fontSize: 16.sp,fontWeight: FontWeight.bold)))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
