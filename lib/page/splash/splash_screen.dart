import 'package:collect_er/data/services/api_service.dart';
import 'package:collect_er/page/join/set_user_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../page_navigator.dart';
import '../login/enter_login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _getAccessToken(context);
  }

  Future<void> _getAccessToken(BuildContext context) async {
    await Future.delayed(Duration(seconds: 2));

    String? _email = await ApiService.getEmailFromToken();

    if (_email == null) {
      //Token 이 없을때 -> 로그인 이나 회원가입
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => EnterLoginPage()),
      );
    } else {
      //Token이 있고 이메일이 검증되었는지 확인
      if (await ApiService.checkUserInfoExist(_email)) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PageNavigator()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => SetUserInfoScreen(email: _email)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 130.0.w,
            ),
            child: Container(
              width: double.infinity,
              child: Image.asset(
                'assets/images/image_logo.png',
              ),
            ),
          ),
          SizedBox(
            height: 50.0.h,
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
    );
  }
}
