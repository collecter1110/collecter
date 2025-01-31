import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'category_selection_widget.dart';

class RankingSelectionWidget extends StatelessWidget {
  const RankingSelectionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFf8f9fa),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CategorySelectionWidget(
              categoryId: 1,
            ),
            Divider(
              thickness: 12.0.h,
              height: 12.0.h,
              color: Colors.white,
            ),
            CategorySelectionWidget(
              categoryId: 4,
            ),
            Divider(
              thickness: 12.0.h,
              height: 12.0.h,
              color: Colors.white,
            ),
            CategorySelectionWidget(
              categoryId: 3,
            ),

            // Padding(
            //   padding: EdgeInsets.symmetric(vertical: 24.0.h),
            //   child: SizedBox(
            //     height: 120.0.h,
            //     child: RankingUserWidget(),
            //   ),
            // ),
            // RankingSelectionWidget(),
          ],
        ),
      ),
    );
  }
}
