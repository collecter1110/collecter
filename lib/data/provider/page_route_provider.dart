import 'package:flutter/material.dart';

class PageRouteProvider extends ChangeNotifier {
  static final PageRouteProvider _instance = PageRouteProvider._internal();
  factory PageRouteProvider() => _instance;
  PageRouteProvider._internal();

  String? _currentRoute;
  PageRoute<dynamic>? _currentPageRoute;

  String? get currentRoute => _currentRoute;
  PageRoute<dynamic>? get currentPageRoute => _currentPageRoute;

  set currentPageRoute(PageRoute<dynamic>? _previousPageRoute) {
    _currentPageRoute = _previousPageRoute;
    _currentRoute = currentPageRoute!.settings.name;
    notifyListeners();
  }

  int? get getCurrentPageNum {
    switch (_currentRoute) {
      case '/':
        return 0;
      case '/search':
        return 1;
      case '/add':
        return 2;
      case '/bookmark':
        return 3;
      case '/user':
        return 4;
      default:
        return null;
    }
  }
}
