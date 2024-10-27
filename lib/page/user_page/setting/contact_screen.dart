import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../components/button/complete_button.dart';
import '../../../components/ui_kit/custom_app_bar.dart';
import '../../../data/services/setting_service.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbar(titleText: '문의하기'),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 24.0.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '불편하신 점이 있으신가요?',
                    style: TextStyle(
                        fontFamily: 'PretendardRegular',
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF212529),
                        height: 1.43),
                  ),
                  SizedBox(
                    height: 30.0.h,
                  ),
                  Text(
                    '이용 중 불편한 점이나 문의사항을 언제든지 알려주세요!\n소중한 의견을 바탕으로 더 나은 서비스를 제공할 수 있도록 노력하겠습니다. :)\n\n문의하신 내용은 최대한 빠르게 확인 후 신속하게 답변드리겠습니다. 다만, 평일(월~금) 10:00 ~ 18:00 사이에만 답변이 가능하며, 주말 및 공휴일에는 답변이 지연될 수 있는 점 양해 부탁드립니다.\n\n항상 이용해 주셔서 감사합니다!',
                    style: TextStyle(
                        fontFamily: 'PretendardRegular',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF495057),
                        height: 1.43),
                  ),
                ],
              ),
              CompleteButton(
                firstFieldState: true,
                secondFieldState: true,
                onTap: () async {
                  SettingService.sendEmail(context);
                },
                text: '1:1 문의하기',
              ),
            ],
          ),
        ));
  }
}
