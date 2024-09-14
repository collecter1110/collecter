import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../ui_kit/keyword.dart';

class SearchListWidget extends StatelessWidget {
  const SearchListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> interests = [
      '책',
      '요리',
      '스릴러',
      '간식',
      '다이어트',
      '식단',
    ];
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0.w),
        child: ListView.separated(
          scrollDirection: Axis.vertical,
          itemCount: 1,
          padding: EdgeInsets.symmetric(vertical: 10.0.h),
          itemBuilder: (context, index) {
            return Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.start,
              spacing: 5.0.w,
              runSpacing: 8.0.h,
              children: interests.map((keyword) {
                return GestureDetector(
                  onTap: () {},
                  child: Keyword(keywordName: keyword),
                );
              }).toList(),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Container(
              height: 20.0.h,
            );
          },
        ),
      ),
    );
  }
}
