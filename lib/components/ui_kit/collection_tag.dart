import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CollectionTag extends StatelessWidget {
  const CollectionTag({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.symmetric(
          horizontal: 10.0.w,
          vertical: 4.0.h,
        ),
        backgroundColor: Color(0xffffe1dd),
        elevation: 0,
      ),
      child: Text(
        'Hot',
        style: TextStyle(
          fontFamily: 'PretendardRegular',
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: Color(0xFFdc595f),
          height: 1.43,
        ),
      ),
    );
  }
}
