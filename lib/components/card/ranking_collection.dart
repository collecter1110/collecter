import 'dart:ui';
import 'package:collect_er/components/ui_kit/tag_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../page/collection/collection_detail_screen.dart';
import '../button/bookmark_button.dart';

import '../ui_kit/collection_tag.dart';
import '../ui_kit/keyword.dart';

class RankingCollection extends StatelessWidget {
  final int index;
  final double ratio;

  const RankingCollection({
    super.key,
    required this.index,
    required this.ratio,
  });

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
    List<String> keywords = [
      '요리',
      '한식',
    ];
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CollectionDetailScreen(
              title: _name[index],
            ),
          ),
        );
      },
      child: AspectRatio(
        aspectRatio: ratio,
        child: Container(
          decoration: ShapeDecoration(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/images/IMG_4498.png',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 16.0.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _name[index],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w600,
                                height: 1.56,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            SizedBox(width: 6.0.w),
                            CollectionTag.getTag(1),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 6.0.h),
                          child: TagTextStyle(
                            name: '웬만한_냉면보다_맛있음',
                            color: Color(0xFFf1f3f5),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.0.h),
                          child: Wrap(
                            direction: Axis.horizontal,
                            alignment: WrapAlignment.start,
                            spacing: 5.0.w,
                            runSpacing: 8.0.h,
                            children: keywords
                                .map((keyword) => Keyword(keywordName: keyword))
                                .toList(),
                          ),
                        ),
                      ],
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
        ),
      ),
    );
  }
}
