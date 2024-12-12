import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/model/category_model.dart';
import '../../data/provider/category_provider.dart';

class Category extends StatefulWidget {
  final int categoryId;
  const Category({
    super.key,
    required this.categoryId,
  });

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  String? categoryName;
  List<CategoryModel> category = [];

  @override
  void initState() {
    super.initState();
    _loadCategoryData();
  }

  void _loadCategoryData() {
    final categoryProvider = context.read<CategoryProvider>();
    category = categoryProvider.categoryInfo;

    categoryName = category
        .firstWhere(
          (category) => widget.categoryId == category.categoryId,
          orElse: () => CategoryModel(
              categoryId: -1, categoryName: '', categoryDescription: ''),
        )
        .categoryName;

    setState(() {
      print('dd');
    }); // 값이 설정된 후 UI를 업데이트
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(6.0.r),
        // border: Border.all(
        //   color: Theme.of(context).primaryColor,
        //   //  color: Color(0xFF45de99),
        //   // width: 0.5.w
        //   width: 1.0.w,
        // ),
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
