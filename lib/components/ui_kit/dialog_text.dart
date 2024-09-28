import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DialogText extends StatelessWidget {
  final String text;
  final Color textColor;
  final VoidCallback onTap;
  const DialogText({
    super.key,
    required this.text,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          onTap();
        },
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
          padding: EdgeInsets.symmetric(
            vertical: 16.0.h,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'PretendardRegular',
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
