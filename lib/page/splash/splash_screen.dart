import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../data/services/setting_service.dart';
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
    getConfig(context);
  }

  Future<void> getConfig(BuildContext context) async {
    bool checkSupabaseConfig = await SettingService.fetchConfigs(context);
    if (checkSupabaseConfig) {
      _getAccessToken(context);
    }
  }

  Future<void> _getAccessToken(BuildContext context) async {
    final storage = FlutterSecureStorage();
    String? _accessToken = await storage.read(key: 'ACCESS_TOKEN');
    await Future.delayed(Duration(seconds: 1));
    if (_accessToken != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PageNavigator()),
      );
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
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 90.0.w,
              ),
              child: Image.asset(
                'assets/images/image_logo.png',
                color: Colors.black,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.42,
            child: Image.asset(
              'assets/images/image_logo_text.png',
              width: 150.0.w,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
