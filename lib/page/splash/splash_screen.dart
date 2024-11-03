import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../data/services/data_service.dart';
import '../../page_navigator.dart';
import '../join/set_user_info_screen.dart';
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
    final storage = FlutterSecureStorage();
    String? userIdString = await storage.read(key: 'USER_ID');
    String? _accessToken = await storage.read(key: 'ACCESS_TOKEN');

    if (_accessToken != null) {
      if (userIdString != null) {
        await DataService.loadInitialData(context);
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
              horizontal: 100.0.w,
            ),
            child: Container(
              width: double.infinity,
              child: Image.asset(
                'assets/images/image_logo_text.png',
              ),
            ),
          ),
          SizedBox(
            height: 16.0.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 70.0.w,
            ),
            child: Container(
              width: double.infinity,
              child: Image.asset(
                'assets/images/image_logo.png',
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
