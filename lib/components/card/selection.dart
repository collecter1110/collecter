import 'package:collect_er/components/button/bookmark_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../page/selection/selection_detail_screen.dart';
import '../ui_kit/keyword.dart';

class Selection extends StatelessWidget {
  final int index;

  const Selection({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    List<String> _titleName = [
      '낫또 김 파스타',
      '깨먹는 초코 오나오',
      '아삭이 고추 비빔밥',
      '오이 두부 비빔밥',
      '다이어트 초코 케이크',
      '송이버섯 숙회',
      '마녀 스프',
    ];
    List<String> _keywords = ['요리', '음식'];
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                SelectionDetailScreen(title: _titleName[index]),
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 0.5,
                    blurRadius: 3,
                    offset: Offset(0, 0),
                  )
                ],
                borderRadius: BorderRadius.circular(8)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                index == 0
                    ? Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(6),
                            topRight: Radius.circular(6),
                          ),
                          child: Container(
                            width: double.infinity,
                            child: Image.asset(
                              'assets/images/IMG_4498.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 12.0.w, vertical: 16.0.h),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_titleName[index]}',
                        style: TextStyle(
                          color: Color(0xFF343A40),
                          fontSize: 15.sp,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600,
                          height: 1.33,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.0.h),
                        child: Wrap(
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.start,
                          spacing: 5.0.w,
                          runSpacing: 8.0.h,
                          children: _keywords.map((keyword) {
                            return Keyword(keywordName: keyword);
                          }).toList(),
                        ),
                      ),
                      SizedBox(
                        height: 4.0.h,
                      ),
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
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 4.0.h,
            right: 0.0,
            child: BookmarkButton(
              listId: 0,
              isBookMarked: true,
              inListDetail: false,
            ),
          ),
        ],
      ),
    );
  }
}
