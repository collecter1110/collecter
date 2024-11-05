import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/button/complete_button.dart';
import '../../components/pop_up/toast.dart';
import '../../components/ui_kit/custom_check_box.dart';
import 'email_authentication_screen.dart';

class UserAgreement extends StatefulWidget {
  const UserAgreement({Key? key}) : super(key: key);

  @override
  State<UserAgreement> createState() => _UserAgreementState();
}

class _UserAgreementState extends State<UserAgreement> {
  @override
  void initState() {
    super.initState();
  }

  bool _isChecked_A = false;
  bool _isChecked_B = false;
  bool _isChecked_C = false;

  Future<void> _launchInBrowser(String link) async {
    Uri url = Uri.parse(link);
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
    )) {
      Toast.notify('유효하지 않은 링크입니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: EdgeInsets.only(top: 184.0.h, left: 16.0.w, right: 16.0.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '서비스 이용을 위해\n약관에 동의해주세요.',
                style: TextStyle(
                  fontFamily: 'PretendardRegular',
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 56.0.h,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFFced4da),
                    width: 0.5.w,
                  ),
                  borderRadius: BorderRadius.circular(8.0.r),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0.h),
                  child: Column(
                    children: [
                      CustomCheckBox(
                        checkState: _isChecked_B,
                        onChanged: (bool? value) {
                          setState(() {
                            _isChecked_B = value!;
                          });
                        },
                        text: "(필수) 서비스 이용약관",
                        onTap: () async {
                          await _launchInBrowser(
                              'https://military-vein-07e.notion.site/12ace8f285118036be2ad800312d62b8');
                        },
                      ),
                      SizedBox(
                        height: 16.0.h,
                      ),
                      CustomCheckBox(
                        checkState: _isChecked_C,
                        onChanged: (bool? value) {
                          setState(() {
                            _isChecked_C = value!;
                          });
                        },
                        text: "(필수) 개인정보 및 이용동의",
                        onTap: () async {
                          await _launchInBrowser(
                              'https://military-vein-07e.notion.site/12ace8f28511807cab33c2bc6948b025');
                        },
                      ),
                      SizedBox(
                        height: 30.0.h,
                      ),
                      CustomCheckBox(
                        checkState: _isChecked_A,
                        onChanged: (bool? value) {
                          setState(() {
                            _isChecked_A = value!;
                            _isChecked_B = value;
                            _isChecked_C = value;
                          });
                        },
                        text: "전체동의",
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30.0.h,
              ),
              CompleteButton(
                  firstFieldState: true,
                  secondFieldState: _isChecked_B && _isChecked_C,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EmailAuthenticationScreen(),
                      ),
                    );
                  },
                  text: '다음')
            ],
          ),
        ),
      ),
    );
  }
}
