import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/button/link_button.dart';
import '../../components/ui_kit/custom_app_bar.dart';
import '../../components/ui_kit/expandable_text.dart';
import '../../components/ui_kit/keyword.dart';
import '../../components/widget/selection_item_widget.dart';

class SelectionDetailScreen extends StatelessWidget {
  final String title;

  const SelectionDetailScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    List<String> keywords = [
      '요리',
      '한식',
    ];
    return Scaffold(
      appBar: CustomAppbar(
          popState: true,
          titleText: '셀렉션',
          titleState: true,
          actionButtonOnTap: () {},
          actionButton: null),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.width,
              color: Colors.pink,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 16.0.w, right: 16.0.w, top: 26.0.h, bottom: 42.0.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22.sp,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w700,
                          height: 1.45,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      SizedBox(
                        width: 10.0.w,
                      ),
                      LinkButton(),
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
                  SizedBox(
                    height: 22.0.h,
                  ),
                  ExpandableText(
                    maxLine: 3,
                    textStyle: TextStyle(
                      color: Color(0xFF343a40),
                      fontSize: 14.sp,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      height: 1.43,
                    ),
                    text:
                        '​🍝주재료🍝\n낫또 1팩\n통마늘\n올리브유\n앤초비 or 액젓\n스파게티 면\n쪽파\n김가루\n🧂양념재료🧂\n치킨스톡\n쯔유\n소금\n후추\n크러쉬드 페퍼',
                  ),
                ],
              ),
            ),
            SelectionItemWidget(
              isOrder: true,
            ),
          ],
        ),
      ),
    );
  }
}
