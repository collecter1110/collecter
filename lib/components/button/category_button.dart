import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryButton extends StatelessWidget {
  final String categoryName;
  final bool categoryState;

  const CategoryButton({
    super.key,
    required this.categoryName,
    required this.categoryState,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: categoryState ? Colors.black : Color(0xFFCED4DA),
        borderRadius: BorderRadius.circular(6.0),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 14.0.w,
        vertical: 8.0.h,
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          categoryName,
          style: TextStyle(
            fontFamily: 'PretendardRegular',
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color:
                categoryState ? Theme.of(context).primaryColor : Colors.white,
            height: 1.43,
          ),
        ),
      ),
    );
  }
}
