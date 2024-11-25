import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../components/widget/splash_widget.dart';
import '../../page_navigator.dart';
import '../login/enter_login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Future<bool> _checkAccessToken;
  @override
  void initState() {
    super.initState();
    _checkAccessToken = _getAccessToken();
  }

  Future<bool> _getAccessToken() async {
    final storage = FlutterSecureStorage();
    String? _accessToken = await storage.read(key: 'ACCESS_TOKEN');
    if (_accessToken != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkAccessToken,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashWidget();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.data == true) {
          return PageNavigator();
        } else if (snapshot.data == false) {
          return EnterLoginPage();
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
