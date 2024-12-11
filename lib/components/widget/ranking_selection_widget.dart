import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'category_selection_widget.dart';

class RankingSelectionWidget extends StatelessWidget {
  const RankingSelectionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.0.w, vertical: 24.0.h),
            child: Text(
              '✏️ 컬렉션으로\n셀렉팅 해보세요!',
              style: TextStyle(
                color: Color(0xff343a40),
                fontSize: 24.sp,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            height: 24.0.h,
          ),
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
    );
  }
}
