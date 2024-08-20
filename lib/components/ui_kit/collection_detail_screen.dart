import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../button/bookmark_button.dart';
import 'custom_app_bar.dart';
import 'keyword.dart';
import 'selection.dart';

class CollectionDetailScreen extends StatelessWidget {
  final String title;
  const CollectionDetailScreen({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    List<String> keywords = ['요리', '레시피'];
    return Scaffold(
      appBar: CustomAppbar(
          popState: true,
          titleText: '컬렉션',
          titleState: true,
          actionButtonOnTap: () {},
          actionButton: null),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: 16.0.w, right: 16.0.w, top: 26.0.h, bottom: 26.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22.sp,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w700,
                          height: 1.4,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      BookmarkButton(
                        listId: 0,
                        isBookMarked: true,
                        inListDetail: true,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 22.0.h,
                  ),
                  Text(
                    '내가 좋아하는 간단한 집밥 레시피',
                    style: TextStyle(
                      color: Color(0xFF343a40),
                      fontSize: 14.sp,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      height: 1.43,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                  SizedBox(
                    height: 10.0.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '김가희',
                        style: TextStyle(
                          color: Color(0xFF868e96),
                          fontSize: 13.sp,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w400,
                          height: 1.15,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.0.w),
                        child: Image.asset(
                          'assets/images/image_vertical_line.png',
                          fit: BoxFit.contain,
                          color: Color(0xFFADB5BD),
                          height: 10.0.h,
                        ),
                      ),
                      Text(
                        '2024.08.19',
                        style: TextStyle(
                          color: Color(0xFF868e96),
                          fontSize: 13.sp,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w400,
                          height: 1.15,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 22.0.h,
                  ),
                  Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.start,
                    spacing: 5.0.w,
                    runSpacing: 5,
                    children: keywords.map((keyword) {
                      return CollectionKeyword(keywordName: keyword);
                    }).toList(),
                  ),
                  SizedBox(
                    height: 40.0.h,
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 24.0.h,
                      crossAxisSpacing: 10.0.w,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: 7,
                    itemBuilder: (context, index) {
                      return Selection(
                        index: index,
                        //ratio: 0.8,
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
