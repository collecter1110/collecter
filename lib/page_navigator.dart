import 'package:collect_er/page/bookmark_page/bookmark_screen.dart';
import 'package:collect_er/page/main_page/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'components/button/nav_button.dart';
import 'page/add_page/add_screen.dart';
import 'page/search_page/search_screen.dart';
import 'page/user_page/user_screen.dart';

class PageNavigator extends StatefulWidget {
  PageNavigator({super.key});

  @override
  State<PageNavigator> createState() => _PageNavigatorState();
}

class _PageNavigatorState extends State<PageNavigator> {
  int selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    MainScreen(),
    SearchScreen(),
    AddScreen(),
    BookmarkScreen(),
    UserScreen(),
  ];

  void _onTap(int index) {
    setState(() {
      selectedIndex = index;
      print(selectedIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: IndexedStack(
        index: selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomAppBar(
        height: 60.h,
        padding: EdgeInsets.only(
          bottom: 10.0,
        ),
        color: Colors.black,
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            NavButton(
              isSelected: selectedIndex == 0,
              iconName: 'tab_home',
              onTap: () => _onTap(0),
            ),
            NavButton(
              isSelected: selectedIndex == 1,
              iconName: 'tab_search',
              onTap: () => _onTap(1),
            ),
            NavButton(
              isSelected: selectedIndex == 2,
              iconName: 'tab_add',
              onTap: () => _onTap(2),
            ),
            NavButton(
              isSelected: selectedIndex == 3,
              iconName: 'tab_bookmark',
              onTap: () => _onTap(3),
            ),
            NavButton(
              isSelected: selectedIndex == 4,
              iconName: 'tab_user',
              onTap: () => _onTap(4),
            ),
          ],
        ),
      ),
    );
  }
}
