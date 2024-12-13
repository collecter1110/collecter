import 'package:collecter/data/provider/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/model/category_model.dart';
import '../card/category_thumb.dart';

class LikeWidget extends StatelessWidget {
  const LikeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(builder: (context, provider, child) {
      final List<CategoryModel>? _categoryInfo;

      _categoryInfo = provider.categoryInfo;

      if (_categoryInfo == null || _categoryInfo.isEmpty) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else {
        return _categoryInfo.isNotEmpty
            ? GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(vertical: 12.0.h),
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12.0.h,
                  crossAxisSpacing: 12.0.w,
                  childAspectRatio: 1.0,
                ),
                itemCount: _categoryInfo.length,
                itemBuilder: (context, index) {
                  int _cateoryId = _categoryInfo![index].categoryId;
                  return CategoryThumb(categoryId: _cateoryId);
                },
              )
            : const Center(
                child: Text('Error occurred.'),
              );
      }
    });
  }
}
