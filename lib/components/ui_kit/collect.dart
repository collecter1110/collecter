import 'package:collect_er/components/button/bookmark_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Collect extends StatelessWidget {
  const Collect({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ListDetailPage(
        //       listId: usersBookmarkLists[index].id,
        //       isBookmarked: usersBookmarkLists[index].isBookmarked,
        //     ),
        //   ),
        // );
      },
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 180.0.h,
                width: double.infinity,
                decoration: ShapeDecoration(
                  color: Color(0xFFF1F3F5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              SizedBox(
                height: 12.0.h,
              ),
              Text(
                'dd',
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
                  Text(
                    'dd',
                    style: TextStyle(
                      color: Color(0XFF868E96),
                      fontSize: 12.sp,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      height: 1.5.h,
                    ),
                  ),
                ],
              )
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
