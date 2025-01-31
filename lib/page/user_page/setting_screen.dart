import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/button/setting_button.dart';
import '../../components/pop_up/toast.dart';
import '../../components/ui_kit/custom_app_bar.dart';
import '../../data/services/api_service.dart';
import '../../main.dart';
import 'setting/announcement_screen.dart';
import 'setting/contact_screen.dart';
import 'setting/app_version_screen.dart';
import 'setting/delete_user_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AnnouncementScreen(),
                        settings: RouteSettings(name: '/user'),
                      ),
                    );
                  },
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
                  onTap: () async {
                    Uri url = Uri.parse(
                        'https://military-vein-07e.notion.site/12ace8f285118036be2ad800312d62b8');
                    if (!await launchUrl(
                      url,
                      mode: LaunchMode.inAppWebView,
                    )) {
                      Toast.notify('유효하지 않은 링크입니다.');
                    }
                  },
                  text: '이용 약관',
                ),
                SettingButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppVersionScreen(),
                        settings: RouteSettings(name: '/user'),
                      ),
                    );
                  },
                  text: '버전 정보',
                ),
                SettingButton(
                    onTap: () async {
                      bool? isDelete = await Toast.showConfirmationDialog(
                          context, '로그아웃 하시겠습니까?');
                      if (isDelete == null) {
                        return;
                      }
                      if (isDelete) {
                        await ApiService.logout();
                        MyApp.restartApp();
                      }
                    },
                    text: '로그아웃'),
                SizedBox(
                  height: 10.0.h,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DeleteUserScreen(),
                          settings: RouteSettings(name: '/user'),
                        ),
                      );
                    },
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
