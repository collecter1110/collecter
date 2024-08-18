import 'package:flutter/material.dart';

class PageRouteProvider extends ChangeNotifier {
  static final PageRouteProvider _instance = PageRouteProvider._internal();
  factory PageRouteProvider() => _instance;
  PageRouteProvider._internal();

  String? _currentRoute;
  PageRoute<dynamic>? _currentPageRoute;

  String? get currentRoute => _currentRoute;
  PageRoute<dynamic>? get currentPageRoute => _currentPageRoute;

  set currentPageRoute(PageRoute<dynamic>? value) {
    _currentPageRoute = value;
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

class CustomRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _saveScreenView(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _saveScreenView(previousRoute, route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _saveScreenView(newRoute, oldRoute);
  }

  void _saveScreenView(Route<dynamic>? newRoute, Route<dynamic>? oldRoute) {
    if (newRoute is PageRoute) {
      PageRouteProvider().currentPageRoute = newRoute;
    }
  }
}
