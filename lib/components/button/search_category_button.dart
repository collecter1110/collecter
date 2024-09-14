import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchCategoryButton extends StatelessWidget {
  final String categoryName;
  final bool buttonState;
  const SearchCategoryButton({
    super.key,
    required this.categoryName,
    required this.buttonState,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.0),
        color: buttonState
            ? Theme.of(context).primaryColor.withOpacity(0.3)
            : Colors.white,
        border: Border.all(
          color: buttonState
              ? Theme.of(context).primaryColor
              : const Color(0xFFf1f3f5),
          width: 1.0,
          style: BorderStyle.solid,
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 14.0.w),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          categoryName,
          style: TextStyle(
            color: buttonState ? Colors.black : const Color(0xffADB5BD),
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            height: 1.43,
          ),
        ),
      ),
    );
  }
}
