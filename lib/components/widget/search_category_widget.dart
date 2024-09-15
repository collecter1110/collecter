import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/provider/search_provider.dart';
import '../button/dropdown_tab_bar_button.dart';
import '../button/sub_category_button.dart';

class SearchCategoryWidget extends StatelessWidget {
  const SearchCategoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(builder: (context, provider, child) {
      final List<String> _subCategoryList = provider.subCategoryNames;
      final String _selectCategoryName = provider.selectedCategoryName;
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          DropdownTabBarButton(selectedCategoryName: _selectCategoryName),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: _subCategoryList.asMap().entries.map((entry) {
              int index = entry.key;
              var name = entry.value;
              return Padding(
                padding: EdgeInsets.only(left: 10.0.w),
                child: SubCategoryButton(
                    subCategoryName: name,
                    index: index,
                    selectedIndex: provider.selectedSubCategoryIndex,
                    onTap: (value) {
                      provider.setSubCategoryIndex = index;
                    }),
              );
            }).toList(),
          )
        ],
      );
    });
  }
}
