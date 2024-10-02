import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/provider/keyword_provider.dart';

class KeywordButton extends StatelessWidget {
  final String keywordName;
  final int index;
  const KeywordButton({
    super.key,
    required this.keywordName,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: Color(0xFF212529),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 4.0.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              keywordName,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 11.0.sp,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
            SizedBox(
              width: 6.0.w,
            ),
            InkWell(
              onTap: () {
                Provider.of<KeywordProvider>(context, listen: false)
                    .deleteKeyword(index);
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
      ),
    );
  }
}
