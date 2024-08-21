import 'package:collect_er/components/widget/selection_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/button/bookmark_button.dart';
import '../../components/ui_kit/custom_app_bar.dart';
import '../../components/ui_kit/keyword.dart';
import '../../components/card/selection.dart';
import '../../components/ui_kit/tag.dart';

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
                  left: 16.0.w, right: 16.0.w, top: 26.0.h, bottom: 42.h),
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
                          fontSize: 12.sp,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.0.w),
                        child: Image.asset(
                          'assets/images/image_vertical_line.png',
                          fit: BoxFit.contain,
                          color: Color(0xFF868e96),
                          height: 10.0.h,
                        ),
                      ),
                      Text(
                        '2024.08.19',
                        style: TextStyle(
                          color: Color(0xFF868e96),
                          fontSize: 12.sp,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 32.0.h,
                  ),
                  Tag(
                    name: '#한식\n#우리집이국수맛집\n#웬만한_냉면보다_맛있음',
                    color: Color(0xFF868E96),
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
                      return Keyword(keywordName: keyword);
                    }).toList(),
                  ),
                ],
              ),
            ),
            Container(
              color: Color(0xFFf8f9fa),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 12.0.h),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'SELECTION',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16.sp,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 18.0.w,
                      vertical: 20.0.h,
                    ),
                    child: SelectionWidget(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
