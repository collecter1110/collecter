import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchBarButton extends StatelessWidget {
  const SearchBarButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/search');
        },
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: EdgeInsets.symmetric(vertical: 16.0.h, horizontal: 14.0.w),
          backgroundColor: Colors.white,
          side: BorderSide(
            // 테두리 추가
            color: Color(0xFFDEE2E6), // 테두리 색상
            width: 1.0, // 테두리 두께
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/icons/tab_search.png',
              height: 16.h,
            ),
            Text(
              '검색해보세요.',
              style: TextStyle(
                fontFamily: 'PretendardRegular',
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Color(0xFF343A40),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
