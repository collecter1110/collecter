import 'package:collect_er/components/button/bookmark_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Collection extends StatelessWidget {
  final int index;

  const Collection({
    super.key,
    required this.index,
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
    return GestureDetector(
      onTap: () {},
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1 / 1.1,
                child: Container(
                  decoration: ShapeDecoration(
                    color: Color(0xFFF1F3F5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              AspectRatio(
                aspectRatio: 1 / 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_name[index]}',
                      style: TextStyle(
                        color: Color(0xFF343A40),
                        fontSize: 14.sp,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                        height: 1.42.h,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    SizedBox(
                      height: 4.0.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '김가희',
                          style: TextStyle(
                            color: Color(0xFF868E96),
                            fontSize: 12.sp,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                            height: 1.5.h,
                          ),
                        ),
                        SizedBox(
                          width: 8.0.w,
                        ),
                        // Text(
                        //   'dd',
                        //   style: TextStyle(
                        //     color: Color(0XFF868E96),
                        //     fontSize: 12.sp,
                        //     fontFamily: 'Pretendard',
                        //     fontWeight: FontWeight.w500,
                        //     height: 1.5.h,
                        //   ),
                        // ),
                      ],
                    )
                  ],
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
