import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LevelButton extends StatelessWidget {
  const LevelButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.symmetric(
          horizontal: 10.0.w,
          vertical: 3.0.h,
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      child: Text(
        '@ 뉴비',
        style: TextStyle(
          fontFamily: 'PretendardRegular',
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).primaryColor,
          height: 1.4,
        ),
      ),
    );
  }
}
