import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthenticationButton extends StatelessWidget {
  final Future<void> Function() onTap;
  const AuthenticationButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onTap();
      },
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 14.0.w,
          vertical: 6.0.h,
        ),
        backgroundColor: Colors.black,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: Size.zero,
      ),
      child: Text(
        '인증',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'PretendardRegular',
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
