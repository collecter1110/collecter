import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../card/ranking_collection.dart';

class RankingCollectionWidget extends StatelessWidget {
  const RankingCollectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> _name = [
      '나만의 레시피북',
      '다이어트 레시피',
      '여름 코디룩',
      '사고 싶은 화장품 리스트',
      '저소음 기계식 키보드 리스트',
      '읽은 책 목록',
      '읽고 싶은 책 목록',
    ];
    final double _collectionRatio = 2.4;
    return GridView.builder(
        padding: EdgeInsets.symmetric(vertical: 22.0.h),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisSpacing: 14.0.h,
          crossAxisSpacing: 10.0.w,
          childAspectRatio: _collectionRatio,
        ),
        itemCount: _name.length,
        itemBuilder: (context, index) {
          return RankingCollection(
            index: index,
            ratio: _collectionRatio,
          );
        });
  }
}
