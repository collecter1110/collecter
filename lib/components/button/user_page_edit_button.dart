import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserPageEditButton extends StatelessWidget {
  final String name;
  final VoidCallback onTap;
  const UserPageEditButton({
    super.key,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          onTap();
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
          minimumSize: Size.zero,
          padding: EdgeInsets.symmetric(
            vertical: 6.0.h,
          ),
          backgroundColor: Color(0xFFdee2e6),
          elevation: 0,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          name,
          style: TextStyle(
            fontFamily: 'PretendardRegular',
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            height: 1.43,
          ),
        ),
      ),
    );
  }
}
