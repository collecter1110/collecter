import 'package:collecter/data/model/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/provider/category_provider.dart';
import 'category.dart';

class CategoryBanner extends StatelessWidget {
  final bool showDescription;
  final int categoryId;

  CategoryBanner({
    required this.showDescription,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(builder: (context, provider, child) {
      final categoryProvider = context.read<CategoryProvider>();
      List<CategoryModel> category = categoryProvider.categoryInfo;

      String? categoryDescription = category
          .firstWhere(
            (category) => categoryId == category.categoryId,
            orElse: () => CategoryModel(
                categoryId: -1, categoryName: '', categoryDescription: ''),
          )
          .categoryDescription;

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.0.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Category(
              categoryId: categoryId,
            ),
            showDescription
                ? Padding(
                    padding: EdgeInsets.only(top: 12.0.h),
                    child: Text(
                      categoryDescription!,
                      style: TextStyle(
                        color: Color(0xff343a40),
                        fontSize: 16.sp,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : SizedBox.shrink()
          ],
        ),
      );
    });
  }
}
