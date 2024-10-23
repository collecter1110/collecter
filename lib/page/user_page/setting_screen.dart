import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/button/setting_button.dart';
import '../../components/ui_kit/custom_app_bar.dart';
import 'setting/contact_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> _name = ['공지사항', '문의하기', '이용 약관', '버전 정보', '로그아웃'];
    return Scaffold(
      appBar: CustomAppbar(
        titleText: '설정',
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 24.0.h),
            child: Column(
              children: [
                SettingButton(
                  onTap: () {},
                  text: '공지사항',
                ),
                SettingButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ContactScreen(),
                        settings: RouteSettings(name: '/user'),
                      ),
                    );
                  },
                  text: '문의하기',
                ),
                SettingButton(
                  onTap: () {},
                  text: '이용 약관',
                ),
                SettingButton(
                  onTap: () {},
                  text: '버전 정보',
                ),
                SettingButton(onTap: () {}, text: '로그아웃'),
                SizedBox(
                  height: 10.0.h,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {},
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.asset(
                          'assets/icons/icon_warning.png',
                          height: 12.0.h,
                          color: Color(
                            0xFFadb5bd,
                          ),
                        ),
                        SizedBox(
                          width: 4.0.w,
                        ),
                        Text(
                          '회원탈퇴',
                          style: TextStyle(
                              fontFamily: 'PretendardRegular',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFadb5bd),
                              height: 1.43),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
