import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SetReportButton extends StatelessWidget {
  final String title;
  final int index;
  int? selectedIndex;
  final ValueSetter<int> onTap;

  SetReportButton({
    super.key,
    required this.title,
    required this.index,
    this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = index == selectedIndex;

    return TextButton(
      onPressed: () {
        onTap(index);
      },
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0.r),
        ),
        padding: EdgeInsets.symmetric(vertical: 12.0.h, horizontal: 16.0.w),
        backgroundColor: isSelected
            ? Theme.of(context).primaryColor.withOpacity(0.3)
            : Colors.white,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: Size.zero,
        side: BorderSide(
          color:
              isSelected ? Theme.of(context).primaryColor : Color(0xFFf1f3f5),
          width: 1.0,
          style: BorderStyle.solid,
        ),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.black : Color(0xFFadb5bd),
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            height: 1.43,
          ),
        ),
      ),
    );
  }
}
