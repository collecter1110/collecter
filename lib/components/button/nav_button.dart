import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/provider/page_route_provider.dart';

class NavButton extends StatelessWidget {
  final int index;

  NavButton({
    super.key,
    required this.index,
  });

  List<String> _iconNames = [
    'tab_home',
    'tab_search',
    'tab_add',
    'tab_bookmark',
    'tab_user',
  ];

  static const List<String> _routeNames = [
    '/',
    '/search',
    '/add',
    '/bookmark',
    '/user',
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<PageRouteProvider>(
      builder: (context, routeState, child) {
        return SizedBox(
          child: Image.asset(
            'assets/icons/${_iconNames[index]}.png',
            color:
                routeState.currentPageRoute?.settings.name == _routeNames[index]
                    ? Colors.white
                    : Colors.grey[600],
            height: 22.h,
          ),
        );
      },
    );
  }
}
