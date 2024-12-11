import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'ranking_collection_widget.dart';

class RankingCollectionWidget extends StatelessWidget {
  const RankingCollectionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CategoryCollectionWidget(
            categoryId: 1,
          ),
          Divider(
            thickness: 12.0.h,
            height: 12.0.h,
            color: Color(0xFFf8f9fa),
          ),
          CategoryCollectionWidget(
            categoryId: 4,
          ),
          Divider(
            thickness: 12.0.h,
            height: 12.0.h,
            color: Color(0xFFf8f9fa),
          ),
          CategoryCollectionWidget(
            categoryId: 3,
          ),
          Divider(
            thickness: 12.0.h,
            height: 12.0.h,
            color: Color(0xFFf8f9fa),
          ),
          CategoryCollectionWidget(
            categoryId: 5,
          ),
        ],
      ),
    );
  }
}
