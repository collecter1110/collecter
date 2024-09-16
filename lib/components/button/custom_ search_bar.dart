import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSearchBar extends StatelessWidget {
  final ValueChanged<String>? onSearch;
  final bool autoFocus;
  final bool enabled;

  CustomSearchBar(
      {Key? key,
      required this.onSearch,
      required this.autoFocus,
      required this.enabled});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      autofocus: autoFocus,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Color(0xffF5F6F7),
        hintText: '검색',
        hintStyle: TextStyle(
          color: Color(0xFFADB5BD),
          fontSize: 15.0.sp,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w500,
          height: 1.3,
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.only(
              top: 18.0.h, bottom: 18.0.h, left: 12.0.w, right: 6.0.w),
          child: Image.asset(
            'assets/icons/tab_search.png',
            fit: BoxFit.contain,
            color: Color(0xFFADB5BD),
            height: 14.0.h,
          ),
        ),
      ),
      style: TextStyle(
        color: Color(0xFF212529),
        fontSize: 15.sp,
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w600,
      ),
      onFieldSubmitted: (String value) {
        if (value.isNotEmpty) {
          onSearch?.call(value);
        }
      },
    );
  }
}
