import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../page/collection/collection_detail_screen.dart';
import '../button/bookmark_button.dart';
import '../ui_kit/keyword.dart';

class Collection extends StatelessWidget {
  final int index;

  const Collection({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    List<String> _titleName = [
      '나만의 레시피북',
      '다이어트 레시피',
      '여름 코디룩',
      '사고 싶은 화장품 리스트',
      '저소음 기계식 키보드 리스트',
      '읽은 책 목록',
      '읽고 싶은 책 목록',
    ];
    List<String> _keywords = [
      '요리',
      '한식',
    ];
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CollectionDetailScreen(title: _titleName[index]),
          ),
        );
      },
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1 / 1,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Color(0xFFf1f3f5),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.black.withOpacity(0.1),
                      //     spreadRadius: 0.5,
                      //     blurRadius: 3,
                      //     offset: Offset(0, 0),
                      //   )
                      // ],
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      index == 0
                          ? Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(6),
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
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.0.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 6.0.h,
                      ),
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
                        maxLines: 1,
                      ),
                      Text(
                        '45',
                        style: TextStyle(
                          color: Color(0xFF868e96),
                          fontSize: 14.sp,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w400,
                          height: 1.43,
                        ),
                      ),
                      index == 0
                          ? Padding(
                              padding: EdgeInsets.only(top: 10.0.h),
                              child: Wrap(
                                direction: Axis.horizontal,
                                alignment: WrapAlignment.start,
                                spacing: 5.0.w,
                                runSpacing: 8.0.h,
                                children: _keywords.map((keyword) {
                                  return Keyword(keywordName: keyword);
                                }).toList(),
                              ),
                            )
                          : SizedBox.shrink()
                    ],
                  ),
                ),
              ),
            ],
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
