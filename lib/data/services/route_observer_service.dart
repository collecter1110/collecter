import 'package:flutter/material.dart';

import '../provider/page_route_provider.dart';
import 'locator.dart';

class RouteObserverService extends RouteObserver<PageRoute<dynamic>> {
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        locator<PageRouteProvider>().currentPageRoute = newRoute;
      });
    }
  }
}
