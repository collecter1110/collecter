import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TagText extends StatelessWidget {
  final List<dynamic> tags;
  final int? maxLine;

  const TagText({
    super.key,
    required this.tags,
    this.maxLine,
  });

  @override
  Widget build(BuildContext context) {
    final tagsText = tags.map((tag) => '#$tag').join('  ');

    return Text(
      tagsText,
      style: TextStyle(
        color: Color(0xFF868E96),
        fontFamily: 'Pretendard',
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        height: 1.33,
      ),
      maxLines: maxLine,
      overflow: TextOverflow.ellipsis,
    );
  }
}
