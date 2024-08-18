import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'page_navigator.dart';

void main() {
  runApp(
    ScreenUtilInit(
      builder: (BuildContext context, child) => const MaterialApp(
        home: MyApp(),
        debugShowCheckedModeBanner: false,
      ),
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
            // titleTextStyle: TextStyle(
            //   color: Colors.black,
            //   //fontSize: Sizes.size16 + Sizes.size2,
            //   fontWeight: FontWeight.w600,
            // ),
          )),
      home: PageNavigator(),
    );
  }
}
