import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../main.dart';
import 'api_service.dart';

class LifeCycleObserverService with WidgetsBindingObserver {
  DateTime? _backgroundTime;
  final int _inactiveDuration = 5;

  LifeCycleObserverService() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ApiService.disposeSubscriptions();
      print('앱 새로고침 또는 시작 시 구독 해제 완료');
    });
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      _backgroundTime = DateTime.now();
      await ApiService.disposeSubscriptions();
    } else if (state == AppLifecycleState.resumed) {
      if (_backgroundTime != null) {
        final timeInBackground = DateTime.now().difference(_backgroundTime!);
        if (timeInBackground.inMinutes >= _inactiveDuration) {
          _restartApp();
        } else {
          final storage = FlutterSecureStorage();
          final userIdString = await storage.read(key: 'USER_ID');
          if (userIdString != null) {
            await ApiService.restartSubscriptions();
          }
          _backgroundTime = null;
        }
      }
    }
  }

  void _restartApp() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      MyApp.restartApp();
    });
  }
}
