import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/model/category_model.dart';
import '../../data/provider/category_provider.dart';

class CategoryButton extends StatelessWidget {
  final ValueSetter<int> onTap;
  final int categoryId;

  int? selectedCategoryId;
  CategoryButton({
    super.key,
    required this.onTap,
    this.selectedCategoryId,
    required this.categoryId,
  });
  String? categoryName;
  List<CategoryModel> category = [];
  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.read<CategoryProvider>();
    category = categoryProvider.categoryInfo;

    categoryName = category
        .firstWhere(
          (category) => categoryId == category.categoryId,
          orElse: () => CategoryModel(
              categoryId: -1, categoryName: '', categoryDescription: ''),
        )
        .categoryName;
    bool buttonState = categoryId == selectedCategoryId;

    return TextButton(
      onPressed: () {
        onTap(categoryId);
      },
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0.r),
          side: BorderSide(
            color: buttonState
                ? Theme.of(context).primaryColor
                : Color(0xFFf1f3f5),
            width: 1.0.w,
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 3.0.h, horizontal: 8.0.w),
        backgroundColor: buttonState
            ? Theme.of(context).primaryColor.withOpacity(0.4)
            : Colors.white,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: Size.zero,
      ),
      child: Text(
        categoryName ?? '',
        style: TextStyle(
          color: buttonState ? Color(0xFF343a40) : Color(0xFFadb5bd),
          fontSize: 12.sp,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w600,
          height: 1.3,
        ),
      ),
    );
  }
}
