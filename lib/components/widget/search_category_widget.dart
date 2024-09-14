import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../button/dropdown_tab_bar_button.dart';
import '../button/search_category_button.dart';

class SearchKeywordWidget extends StatelessWidget {
  const SearchKeywordWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        DropdownTabBarButton(
          setCategory: (value) {},
        ),
        SizedBox(width: 10.0.w),
        SearchCategoryButton(
          categoryName: 'Keyword',
          buttonState: true,
        ),
        SizedBox(width: 10.0.w),
        SearchCategoryButton(
          categoryName: 'Keyword',
          buttonState: true,
        ),
      ],
    );
  }
}
