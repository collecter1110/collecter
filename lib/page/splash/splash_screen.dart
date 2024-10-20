import 'package:collect_er/data/services/api_service.dart';
import 'package:collect_er/page/join/set_user_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../data/services/data_management.dart';
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
    // await Future.delayed(Duration(seconds: 2));
    final storage = FlutterSecureStorage();
    String? userIdString = await storage.read(key: 'USER_ID');
    bool _isAccessToken = await ApiService.checkAccessToken();

    if (_isAccessToken) {
      if (userIdString != null) {
        await DataManagement.loadInitialData(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PageNavigator()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SetUserInfoScreen()),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => EnterLoginPage()),
      );
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
