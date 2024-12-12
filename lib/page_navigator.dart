import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'components/button/nav_button.dart';
import 'data/provider/page_route_provider.dart';
import 'data/services/locator.dart';
import 'data/services/route_observer_service.dart';
import 'data/services/image_service.dart';
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

  final List<String> _routeNames = [
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
    initializeData();
  }

  Future<void> initializeData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ImageService.getPermission();
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
        resizeToAvoidBottomInset: true,
        body: Navigator(
          key: _navigatorKey,
          initialRoute: _routeNames[0],
          onGenerateRoute: _onGenerateRoute,
          observers: [RouteObserverService()],
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
                if (locator<PageRouteProvider>().getCurrentPageNum == index) {
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
