import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectStatusTag extends StatelessWidget {
  final String? userName;
  final String times;
  const SelectStatusTag({
    super.key,
    this.userName,
    required this.times,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(50.0),
        border: Border.all(
          color: Theme.of(context).primaryColor,
          //  color: Color(0xFF45de99),
          // width: 0.5.w
          width: 1.2.w,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 2.0.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset('assets/icons/icon_check.png',
                    height: 14.0.h, color: Color(0xFF1b4d3e)),
                SizedBox(
                  width: 4.0.w,
                ),
                Text(
                  times,
                  style: TextStyle(
                    color: Color(0xFF868e96),
                    fontSize: 10.0.sp,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w700,
                    height: 1.8,
                  ),
                ),
              ],
            ),
            userName == null
                ? SizedBox.shrink()
                : Text(
                    userName!,
                    style: TextStyle(
                      color: Color(0xFF212529),
                      fontSize: 10.0.sp,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w800,
                      height: 1.8,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
