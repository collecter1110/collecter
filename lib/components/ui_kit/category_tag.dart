import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/model/category_model.dart';
import '../../data/provider/category_provider.dart';

class CategoryTag extends StatelessWidget {
  final int categoryId;
  final bool buttonState;
  CategoryTag({
    super.key,
    required this.categoryId,
    required this.buttonState,
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

    return Container(
      decoration: BoxDecoration(
        color: buttonState
            ? Theme.of(context).primaryColor.withOpacity(0.4)
            : Colors.white,
        borderRadius: BorderRadius.circular(6.0.r),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.4),
          width: 1.0.w,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 3.0.h),
        child: Text(
          categoryName ?? '',
          style: TextStyle(
            color: Color(0xFF343a40),
            fontSize: 12.sp,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
            height: 1.3,
          ),
        ),
      ),
    );
  }
}
