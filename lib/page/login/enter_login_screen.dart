import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../join/email_authentication_screen.dart';

class EnterLoginPage extends StatelessWidget {
  EnterLoginPage({Key? key}) : super(key: key);

  final grayColor = Color(0xff212529);
  final mildGrayColor = Color(0xff868E96);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        //color: Theme.of(context).primaryColor,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 256.h),
                child: Container(
                  height: 84.h,
                  //color: Colors.purple,
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/images/image_logo.png',
                        width: 115.2.w,
                        height: 32.h,
                      ),
                      // SizedBox(
                      //   height: 24.h,
                      // ),
                      Text(
                        "나만의 리스트 관리 플랫폼 리스터",
                        style: TextStyle(
                          fontFamily: 'PretendardRegular',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 40.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0)),
                        padding: EdgeInsets.symmetric(
                            horizontal: 97.5.w, vertical: 20.h),
                        backgroundColor: Colors.black,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/image_google.png',
                            height: 16.0.h,
                          ),
                          SizedBox(
                            width: 10.0.w,
                          ),
                          Text(
                            "구글 계정으로 로그인",
                            style: TextStyle(
                              fontFamily: 'PretendardRegular',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        side: BorderSide(width: 1.0, color: grayColor),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0)),
                        padding: EdgeInsets.symmetric(
                            horizontal: 97.5.w, vertical: 20.h),
                        backgroundColor: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/image_email.png',
                            height: 16.0.h,
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
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    SizedBox(
                      height: 20.h,
                      width: 135.w,
                      child: TextButton(
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
                            padding: EdgeInsets.symmetric(vertical: 0.1.h)),
                        child: FittedBox(
                          child: Text(
                            "아직 회원이 아니신가요?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'PretendardRegular',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: mildGrayColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
