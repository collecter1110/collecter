import 'package:flutter/material.dart';
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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _backgroundTime = DateTime.now();
      ApiService.disposeSubscriptions();
    } else if (state == AppLifecycleState.resumed) {
      if (_backgroundTime != null) {
        final timeInBackground = DateTime.now().difference(_backgroundTime!);
        if (timeInBackground.inMinutes >= _inactiveDuration) {
          ApiService.disposeSubscriptions().then((_) => _restartApp());
        } else {
          ApiService.restartSubscriptions();
        }
        _backgroundTime = null;
      }
    }
  }

  void _restartApp() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      MyApp.restartApp();
    });
  }
}
