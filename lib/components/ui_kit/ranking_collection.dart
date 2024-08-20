import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../button/bookmark_button.dart';
import 'collection_detail_screen.dart';
import 'collection_tag.dart';
import 'keyword.dart';

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
            // color: Color(0xFFf8f9fa),
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
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                        color: Colors.black.withOpacity(0.3),
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
                            CollectionTag(),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 6.0.h),
                          child: Wrap(
                            direction: Axis.horizontal,
                            alignment: WrapAlignment.start,
                            spacing: 5.0.w,
                            runSpacing: 8.0.h,
                            children: keywords
                                .map((keyword) =>
                                    SelectionKeyword(keywordName: keyword))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'heenano',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        height: 1.5.h,
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
