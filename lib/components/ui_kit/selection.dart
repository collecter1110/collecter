import 'package:collect_er/components/button/bookmark_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Selection extends StatelessWidget {
  final double ratio;
  final int index;
  const Selection({
    super.key,
    required this.index,
    required this.ratio,
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
    return GestureDetector(
      onTap: () {},
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: ratio,
                child: Container(
                  decoration: ShapeDecoration(
                    color: Color(0xFFF8F9FA),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                  ),
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
                                  color: Colors.white,
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
                            horizontal: 8.0.w, vertical: 10.0.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_titleName[index]}',
                              style: TextStyle(
                                color: Color(0xFF343A40),
                                fontSize: 14.sp,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w600,
                                height: 1.42,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Text(
                              'irismake',
                              style: TextStyle(
                                color: Color(0XFF868E96),
                                fontSize: 12.sp,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // AspectRatio(
              //   aspectRatio: 1 / 0.3,
              //   child:
              // ),
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
