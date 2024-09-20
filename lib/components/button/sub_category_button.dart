import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubCategoryButton extends StatelessWidget {
  final String subCategoryName;
  final int index;
  int? selectedIndex;
  final ValueSetter<int> onTap;

  SubCategoryButton({
    super.key,
    required this.subCategoryName,
    required this.index,
    this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool _isSelected = index == selectedIndex;

    return TextButton(
      onPressed: () {
        onTap(index);
      },
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        side: BorderSide(
          color: _isSelected ? Color(0xFF868e96) : const Color(0xFFf1f3f5),
          width: 1.0,
          style: BorderStyle.solid,
        ),
        padding: EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 14.0.w),
        backgroundColor: _isSelected ? Colors.white : Colors.white,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: Size.zero,
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          subCategoryName,
          style: TextStyle(
            color: _isSelected ? Colors.black : const Color(0xffADB5BD),
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            height: 1.43,
          ),
        ),
      ),
    );
  }
}
