import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../main.dart';
import 'api_service.dart';

class LifeCycleObserverService with WidgetsBindingObserver {
  DateTime? _backgroundTime;
  final int _inactiveDuration = 5;

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      _backgroundTime = DateTime.now();
      await ApiService.stopSubscriptions();
    } else if (state == AppLifecycleState.resumed) {
      if (_backgroundTime != null) {
        final timeInBackground = DateTime.now().difference(_backgroundTime!);
        if (timeInBackground.inMinutes >= _inactiveDuration) {
          _restartApp();
        } else {
          final storage = FlutterSecureStorage();
          final userIdString = await storage.read(key: 'USER_ID');
          if (userIdString != null) {
            await ApiService.startSubscriptions();
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
