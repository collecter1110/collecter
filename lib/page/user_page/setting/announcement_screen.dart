import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../components/ui_kit/custom_app_bar.dart';

class AnnouncementScreen extends StatelessWidget {
  const AnnouncementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbar(titleText: '공지사항'),
        body: Container(
          child: Center(
            child: Text(
              '공지 사항이 없습니다.',
              style: TextStyle(
                  fontFamily: 'PretendardRegular',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF495057),
                  height: 1.43),
            ),
          ),
        ));
  }
}
