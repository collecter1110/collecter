import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatelessWidget {
  final FocusNode focusNode;
  final String labelText;
  final bool isPassword;
  final String? Function(String?) validator;
  final Function(String) onChanged;
  final TextInputType keyboardType;
  final Widget? suffixIcon;

  const CustomTextFormField({
    Key? key,
    required this.focusNode,
    required this.labelText,
    this.isPassword = false,
    required this.validator,
    required this.onChanged,
    required this.keyboardType,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      obscureText: isPassword,
      validator: validator,
      onChanged: onChanged,
      keyboardType: keyboardType,
      style: TextStyle(
        decorationThickness: 0,
        color: Color(0xff495057),
        fontSize: 14.sp,
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w500,
        height: 1.43,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Color(0xffADB5BD),
          fontSize: 14.sp,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w600,
          height: 1.43,
        ),
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          vertical: 20.0.h,
          horizontal: 16.0.w,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(width: 1.5.w, color: Color(0xFFdee2e6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(width: 1.5.w, color: Color(0xFF868e96)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(width: 1.w, color: Colors.red),
        ),
        errorStyle: TextStyle(
          fontFamily: 'PretendardRegular',
          color: Colors.red,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
