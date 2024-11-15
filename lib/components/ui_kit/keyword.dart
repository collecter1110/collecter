import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Keyword extends StatelessWidget {
  final String keywordName;
  const Keyword({super.key, required this.keywordName});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: Color(0xFF212529),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 3.0.h),
        child: Text(
          keywordName,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 10.0.sp,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}
