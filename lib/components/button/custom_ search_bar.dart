import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/provider/search_provider.dart';

class CustomSearchBar extends StatelessWidget {
  final bool autoFocus;
  final bool enabled;

  CustomSearchBar({
    Key? key,
    required this.autoFocus,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    final _provider = context.read<SearchProvider>();
    return TextFormField(
      initialValue: _provider.searchText,
      enabled: enabled,
      autofocus: autoFocus,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 14.0.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Color(0xffF5F6F7),
        hintText: '검색어를 입력해주세요.',
        hintStyle: TextStyle(
          color: Color(0xFFADB5BD),
          fontSize: 15.0.sp,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w500,
          height: 1.3,
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 12.0.h,
            horizontal: 12.0.w,
          ),
          child: SizedBox(
            height: 20.0.h,
            child: Image.asset(
              'assets/icons/tab_search.png',
              fit: BoxFit.contain,
              color: Color(0xFFADB5BD),
            ),
          ),
        ),
        prefixIconConstraints: BoxConstraints(
          minHeight: 16.0.h,
          minWidth: 16.0.w,
        ),
      ),
      style: TextStyle(
        color: Color(0xFF212529),
        fontSize: 15.sp,
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w600,
      ),
      onFieldSubmitted: (searchText) {
        if (searchText.isNotEmpty) {
          _provider.saveSearchText = searchText;
        }
      },
    );
  }
}
