import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../page/user_page/like_screen.dart';
import '../ui_kit/category_tag.dart';

class CategoryThumb extends StatelessWidget {
  final int categoryId;

  const CategoryThumb({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LikeScreen(
              categoryId: categoryId,
            ),
            settings: RouteSettings(name: '/user'),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
            color: Color(0xFFf1f3f5), borderRadius: BorderRadius.circular(8.r)),
        child: Center(
          child: CategoryTag(
            categoryId: categoryId,
            buttonState: true,
          ),
        ),
      ),
    );
  }
}
