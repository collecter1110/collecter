import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TagText extends StatelessWidget {
  final List<dynamic> tags;
  final Color color;
  final int? maxLine;
  const TagText({
    super.key,
    required this.tags,
    required this.color,
    this.maxLine,
  });

  @override
  Widget build(BuildContext context) {
    final tagsText = tags.map((tag) => '#$tag').join(' ');

    return Text(
      tagsText,
      style: TextStyle(
        color: color,
        fontFamily: 'Pretendard',
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
        height: 1.5,
      ),
      maxLines: maxLine,
      overflow: TextOverflow.ellipsis,
    );
  }
}
