import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:education_app/res/app_colors.dart';
class CustomTextFormField extends StatefulWidget {
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final String? labelText;
  final String hintText;
  final Icon? prefixIcon;
  final Widget? suffixIcon; // Optional custom suffix icon
  final bool isPassword;
  final bool obscureText; // Controlled from outside
  final VoidCallback? onToggleVisibility; // Also controlled externally
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;
  final bool enabled;

  const CustomTextFormField({
    Key? key,
    this.focusNode,
    this.controller,
    this.labelText,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,
    this.obscureText = false,
    this.onToggleVisibility,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLines = 1,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: widget.focusNode,
      cursorColor: AppColors.secondaryColor,
      controller: widget.controller,
      obscureText: widget.isPassword ? widget.obscureText : false,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      maxLines: widget.maxLines,
      enabled: widget.enabled,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon!.icon, color: AppColors.secondaryColor) : null,
        suffixIcon: widget.suffixIcon ??
            (widget.isPassword
                ? IconButton(
              icon: Icon(
                widget.obscureText ? Icons.visibility_off : Icons.visibility,color: AppColors.secondaryColor,
              ),
              onPressed: widget.onToggleVisibility,
            )
                : null),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }
}
