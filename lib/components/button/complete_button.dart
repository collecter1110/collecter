import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CompleteButton extends StatelessWidget {
  final bool firstFieldState;
  final bool secondFieldState;
  final VoidCallback onTap;
  final String text;
  const CompleteButton({
    super.key,
    required this.firstFieldState,
    required this.secondFieldState,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () {
              if (firstFieldState && secondFieldState) {
                onTap();
              }
            },
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: EdgeInsets.symmetric(
                vertical: 16.0.h,
              ),
              backgroundColor: firstFieldState && secondFieldState
                  ? Colors.black
                  : Color(0xFFDEE2E6),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              minimumSize: Size.zero,
            ),
            child: Text(
              text,
              style: TextStyle(
                  fontFamily: 'PretendardRegular',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: firstFieldState && secondFieldState
                      ? Theme.of(context).primaryColor
                      : Colors.white,
                  height: 1.43),
            ),
          ),
        ),
      ],
    );
  }
}
