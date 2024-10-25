import 'package:flutter/material.dart';

import '../../../components/ui_kit/custom_app_bar.dart';
import '../../../data/services/setting_service.dart';

class AppVersionScreen extends StatelessWidget {
  const AppVersionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        titleText: '버전 정보',
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: SettingService.getAppInfo(),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('오류가 발생했습니다.'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('데이터를 불러올 수 없습니다.'));
          }

          final appInfo = snapshot.data!;
          return Center(
            child: Text('현재 버전  ${appInfo["앱 버전"]}'),
          );
        },
      ),
    );
  }
}
