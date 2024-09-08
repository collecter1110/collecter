import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TagTextStyle extends StatelessWidget {
  final String name;
  final Color color;
  const TagTextStyle({super.key, required this.name, required this.color});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '# ',
            style: TextStyle(
              color: color,
              fontFamily: 'PretendardRegular',
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              height: 1,
            ),
          ),
          TextSpan(
            text: name,
            style: TextStyle(
              color: color,
              fontFamily: 'Pretendard',
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
