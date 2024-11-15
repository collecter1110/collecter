import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StatusTag extends StatelessWidget {
  final String? userName;
  final String times;
  const StatusTag({
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
        borderRadius: BorderRadius.circular(50.0.r),
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
            userName == null
                ? SizedBox.shrink()
                : Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/icon_user.svg',
                        colorFilter: ColorFilter.mode(
                            Color(0xFF212529), BlendMode.srcIn),
                        height: 10.0.h,
                      ),
                      SizedBox(
                        width: 4.0.w,
                      ),
                      Text(
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
      ),
    );
  }
}
