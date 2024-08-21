import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Tag extends StatelessWidget {
  final String name;
  final Color color;
  const Tag({super.key, required this.name, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: TextStyle(
        color: color,
        fontSize: 13.sp,
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w500,
        height: 1.5,
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 3,
    );
  }
}
