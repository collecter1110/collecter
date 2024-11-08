import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/button/complete_button.dart';
import '../../page_navigator.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontFamily: 'PretendardRegular',
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF212529),
                  height: 1.5,
                ),
                children: [
                  WidgetSpan(
                    child: Image.asset(
                      'assets/images/image_logo_text.png',
                      height: 28.sp,
                    ),
                  ),
                  TextSpan(
                    text: ' 에 오신 걸\n진심으로 환영합니다!',
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0.h),
            Image.asset(
              'assets/images/welcome.png',
            ),
            SizedBox(
              height: 42.0.h,
            ),
            CompleteButton(
              firstFieldState: true,
              secondFieldState: true,
              text: '시작하기',
              onTap: () async {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => PageNavigator()),
                    (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
