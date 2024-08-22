import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TagTextStyle extends StatelessWidget {
  final String name;
  final Color color;
  const TagTextStyle({super.key, required this.name, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '# ',
          style: TextStyle(
            color: color,
            fontFamily: 'PretendardRegular',
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            height: 1,
          ),
        ),
        Text(
          name,
          style: TextStyle(
            color: color,
            fontSize: 13.sp,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
