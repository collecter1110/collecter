import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/provider/tag_provider.dart';

class TagButton extends StatelessWidget {
  final String tagName;
  final int index;
  const TagButton({super.key, required this.tagName, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100.0),
        border: Border.all(
          color: Color(0xFFe9ecef),
          width: 1.0,
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 4.0.h, horizontal: 10.0.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            tagName,
            style: TextStyle(
              color: Color(0xFF495057),
              fontFamily: 'Pretendard',
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
          SizedBox(
            width: 6.0.w,
          ),
          InkWell(
            onTap: () async {
              await Provider.of<TagProvider>(context, listen: false)
                  .deleteTag(index);
            },
            child: Container(
              height: 10,
              width: 10,
              padding: EdgeInsets.zero,
              child: Image.asset(
                'assets/icons/button_delete.png',
                fit: BoxFit.contain,
                color: Color(0xFF868e96),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
