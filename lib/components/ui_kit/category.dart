import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/model/category_model.dart';
import '../../data/provider/category_provider.dart';

class Category extends StatelessWidget {
  final int categoryId;
  Category({
    super.key,
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

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(6.0.r),
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
