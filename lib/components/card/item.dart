import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../button/link_button.dart';

class Item extends StatelessWidget {
  final int index;
  const Item({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    List<String> _ItemTitle = ['상의', '하의', '신발'];
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0.5,
              blurRadius: 3,
              offset: Offset(0, 0),
            )
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 20.0.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_ItemTitle[index]}',
                style: TextStyle(
                  color: Color(0xFF212529),
                  fontSize: 16.sp,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w700,
                  height: 1.5,
                ),
              ),
              SizedBox(
                height: 8.0.h,
              ),
              Text(
                '엽페',
                style: TextStyle(
                  color: Color(0xFF343a40),
                  fontSize: 13.sp,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 4.0.h,
              ),
              Text(
                '사이즈 M',
                style: TextStyle(
                  color: Color(0xFF343a40),
                  fontSize: 13.sp,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 16.0.h,
              ),
              LinkButton(),
            ],
          ),
        ),
      ),
    );
  }
}
