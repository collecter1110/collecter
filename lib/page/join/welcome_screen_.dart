import 'package:collect_er/components/button/complete_button.dart';
import 'package:collect_er/page_navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/services/data_service.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 184.0.h, left: 20.0.w, right: 20.0.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '원하는 정보를 선택하고 모으고!',
              style: TextStyle(
                fontFamily: 'PretendardRegular',
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Color(0xFF495057),
                height: 1.43,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 18.0.h),
            Text(
              '콜렉터에 오신 걸\n진심으로 환영합니다!',
              style: TextStyle(
                  fontFamily: 'PretendardRegular',
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF212529),
                  height: 1.5),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 82.0.h),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 110.0.w,
              ),
              child: Image.asset(
                'assets/images/image_character_welcome.png',
              ),
            ),
            SizedBox(
              height: 82.0.h,
            ),
            CompleteButton(
              firstFieldState: true,
              secondFieldState: true,
              text: '시작하기',
              onTap: () async {
                await DataService.loadInitialData(context);
                Navigator.of(context).pushAndRemoveUntil(
                    CupertinoPageRoute(builder: (context) => PageNavigator()),
                    (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
