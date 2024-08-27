import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/constants/screen_size.dart';
import '../join/email_authentication_screen.dart';
import 'email_login_screen.dart';

class EnterLoginPage extends StatelessWidget {
  EnterLoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: ViewPaddingTopSize(context)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0.w),
                  child: Text(
                    "나에게 필요한 정보들을 한눈에!",
                    style: TextStyle(
                      fontFamily: 'PretendardRegular',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF212529),
                    ),
                  ),
                ),
                SizedBox(
                  height: 26.0.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 60.0.w,
                  ),
                  child: Container(
                    width: double.infinity,
                    child: Image.asset(
                      'assets/images/image_login_background.png',
                    ),
                  ),
                ),
                SizedBox(
                  height: 34.0.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 130.0.w,
                  ),
                  child: Container(
                    width: double.infinity,
                    child: Image.asset(
                      'assets/images/image_character.png',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 52.0.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EmailLoginScreen(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      side: BorderSide(width: 1.0, color: Color(0xFF343a40)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      backgroundColor: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/image_email.png',
                          height: 18.0.h,
                        ),
                        SizedBox(
                          width: 10.0.w,
                        ),
                        Text(
                          "이메일로 로그인",
                          style: TextStyle(
                            fontFamily: 'PretendardRegular',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const EmailAuthenticationScreen(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      padding: EdgeInsets.symmetric(
                          horizontal: 97.5.w, vertical: 12.h),
                      backgroundColor: Color(0xFF212529),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "회원가입",
                          style: TextStyle(
                            fontFamily: 'PretendardRegular',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryColor,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
