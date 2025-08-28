import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../features/auth_and_profile/view_model/auth_view_model.dart';
import 'custom_button.dart';
import 'custom_text_form_field.dart';

class ForgotPasswordBottomSheet extends StatefulWidget {
  const ForgotPasswordBottomSheet({super.key});

  @override
  State<ForgotPasswordBottomSheet> createState() => _ForgotPasswordBottomSheetState();
}

class _ForgotPasswordBottomSheetState extends State<ForgotPasswordBottomSheet> {
  final TextEditingController emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Reset Password', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 20.h),
          CustomTextFormField(hintText: 'Enter Email',prefixIcon: Icon(Icons.email_outlined),),
          SizedBox(height: 20.h),
          Consumer<AuthViewModel>(
            builder: (context, provider, _) {
              return SizedBox(
                width: double.infinity,
                child: CustomButton(
                  title: 'Reset',
                  isLoading: provider.isLoading,
                  onPressed: () {
                    provider.resetPassword(
                      email: emailController.text.trim(),
                      context: context,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
