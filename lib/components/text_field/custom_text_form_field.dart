import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatter;
  final String labelText;
  final String hinText;
  final bool isPassword;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final TextInputType keyboardType;
  final Widget? suffixIcon;

  const CustomTextFormField({
    Key? key,
    this.controller,
    this.focusNode,
    this.inputFormatter,
    required this.labelText,
    required this.hinText,
    this.isPassword = false,
    this.validator,
    this.onChanged,
    required this.keyboardType,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      inputFormatters: inputFormatter != null ? inputFormatter! : [],
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
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: labelText,
        hintText: hinText,
        hintStyle: TextStyle(
          color: Color(0xffADB5BD),
          fontSize: 14.sp,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w600,
          height: 1.43,
        ),
        labelStyle: TextStyle(
          color: Color(0xFF868e96),
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
          borderRadius: BorderRadius.all(Radius.circular(4.r)),
          borderSide: BorderSide(width: 1.5.w, color: Color(0xFFdee2e6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.r)),
          borderSide:
              BorderSide(width: 1.5.w, color: Theme.of(context).primaryColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.r)),
          borderSide: BorderSide(width: 1.w, color: Colors.red),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.r)),
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
