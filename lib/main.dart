import 'package:collect_er/data/provider/page_route_provider.dart';
import 'package:collect_er/data/provider/tag_provider.dart';
import 'package:collect_er/page/login/enter_login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'data/provider/keyword_provider.dart';
import 'page_navigator.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<PageRouteProvider>(
          create: (context) => PageRouteProvider(),
        ),
        ChangeNotifierProvider<TagProvider>(
          create: (context) => TagProvider(),
        ),
        ChangeNotifierProvider<KeywordProvider>(
          create: (context) => KeywordProvider(),
        ),
      ],
      builder: (context, child) {
        return ScreenUtilInit(
          builder: (BuildContext context, child) => const MaterialApp(
            home: MyApp(),
            debugShowCheckedModeBanner: false,
          ),
          designSize: const Size(390, 844),
          minTextAdapt: true,
          splitScreenMode: true,
        );
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee Conti',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xffaaf0d1),
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: EnterLoginPage(),
    );
  }
}
