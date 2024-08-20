import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LinkButton extends StatelessWidget {
  const LinkButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
          minimumSize: Size.zero,
          padding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 2.0.h),
          backgroundColor: Color(0xFFf1f3f5),
          elevation: 0,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/icons/icon_link.png',
              color: Color(0xFF868e96),
              height: 10.0.h,
            ),
            SizedBox(
              width: 6.0.w,
            ),
            Text(
              'Link',
              style: TextStyle(
                fontFamily: 'PretendardRegular',
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xFF868e96),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
