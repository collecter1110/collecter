import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UsersArchiveButton extends StatelessWidget {
  final VoidCallback onTap;
  final int number;
  final String name;
  const UsersArchiveButton({
    super.key,
    required this.onTap,
    required this.number,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '$number',
              style: TextStyle(
                color: Color(0xFF212529),
                fontSize: 16.sp,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w700,
                height: 1.5,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              name,
              style: TextStyle(
                color: Color(0xFF212529),
                fontSize: 12.sp,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
