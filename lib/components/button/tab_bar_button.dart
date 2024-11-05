import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TabBarButton extends StatelessWidget {
  final String tabName;
  final bool buttonState;

  const TabBarButton({
    super.key,
    required this.tabName,
    required this.buttonState,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: buttonState ? Colors.black : Color(0xFFCED4DA),
        borderRadius: BorderRadius.circular(6.0.r),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 14.0.w,
        vertical: 8.0.h,
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          tabName,
          style: TextStyle(
            fontFamily: 'PretendardRegular',
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: buttonState ? Theme.of(context).primaryColor : Colors.white,
            height: 1.43,
          ),
        ),
      ),
    );
  }
}
