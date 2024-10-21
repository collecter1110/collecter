import 'package:collect_er/components/button/nav_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

import 'data/provider/page_route_provider.dart';
import 'data/services/storage_service.dart';
import 'page/add_page/add_screen.dart';
import 'page/bookmark_page/bookmark_screen.dart';
import 'page/home_page/home_screen.dart';
import 'page/search_page/search_screen.dart';
import 'page/user_page/user_screen.dart';

class PageNavigator extends StatefulWidget {
  PageNavigator({Key? key}) : super(key: key);

  @override
  State<PageNavigator> createState() => _PageNavigatorState();
}

class _PageNavigatorState extends State<PageNavigator> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  final _pages = [
    HomeScreen(),
    SearchScreen(),
    AddScreen(),
    BookmarkScreen(),
    UserScreen(),
  ];

  static const List<String> _routeNames = [
    '/',
    '/search',
    '/add',
    '/bookmark',
    '/user',
  ];

  MaterialPageRoute _onGenerateRoute(RouteSettings settings) {
    final index = _routeNames.indexOf(settings.name!);
    if (index != -1) {
      return MaterialPageRoute(
        builder: (context) => _pages[index],
        settings: settings,
      );
    } else {
      throw Exception('Unknown route: ${settings.name}');
    }
  }

  @override
  void initState() {
    super.initState();

    getPermission();
  }

  Future<void> getPermission() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      bool isPermissionGranted = await StorageService.requestPhotoPermission();

      if (isPermissionGranted) {
      } else {
        openAppSettings();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 5,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Navigator(
          key: _navigatorKey,
          initialRoute: _routeNames[0],
          onGenerateRoute: _onGenerateRoute,
          observers: [CustomRouteObserver()],
        ),
        bottomNavigationBar: BottomAppBar(
          padding: EdgeInsets.only(
            top: 12.0.h,
            bottom: 16.0.h,
          ),
          height: 60.0.h,
          color: Colors.black,
          child: TabBar(
            dividerHeight: 0,
            indicatorColor: Colors.transparent,
            isScrollable: false,
            onTap: (index) {
              setState(() {
                if (PageRouteProvider().getCurrentPageNum == index) {
                  print('같은 페이지');
                  return;
                }
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _navigatorKey.currentState?.pushNamedAndRemoveUntil(
                    _routeNames[index],
                    (Route<dynamic> route) => false,
                  );
                });
              });
            },
            tabs: List.generate(
              5,
              (index) => NavButton(index: index),
            ),
          ),
        ),
      ),
    );
  }
}
