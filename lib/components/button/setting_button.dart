import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  const SettingButton({
    super.key,
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
              onTap();
            },
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0.r),
              ),
              padding:
                  EdgeInsets.symmetric(vertical: 12.0.h, horizontal: 16.0.w),
              backgroundColor: Color(0xFFf8f9fa),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              minimumSize: Size.zero,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  text,
                  style: TextStyle(
                      fontFamily: 'PretendardRegular',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF495057),
                      height: 1.43),
                ),
                Image.asset(
                  'assets/icons/icon_arrow_right.png',
                  height: 12.0.h,
                  color: Color(
                    0xFFadb5bd,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
