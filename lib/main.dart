import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'data/provider/collection_provider.dart';
import 'data/provider/item_provider.dart';
import 'data/provider/keyword_provider.dart';
import 'data/provider/page_route_provider.dart';
import 'data/provider/ranking_provider.dart';
import 'data/provider/search_provider.dart';
import 'data/provider/selecting_provider.dart';
import 'data/provider/selection_provider.dart';
import 'data/provider/tag_provider.dart';
import 'data/provider/user_info_provider.dart';
import 'data/services/life_cycle_observer_service.dart';
import 'data/services/locator.dart';
import 'page/splash/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding.instance.addObserver(LifeCycleObserverService());
  await initializeAppSetting();
  runApp(MyAppWrapper());
}

Future<void> initializeAppSetting() async {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  setupLocator();
}

class MyAppWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PageRouteProvider>(
          create: (context) => locator<PageRouteProvider>(),
        ),
        ChangeNotifierProvider<RankingProvider>(
          create: (context) => locator<RankingProvider>(),
        ),
        ChangeNotifierProvider<TagProvider>(
          create: (context) => TagProvider(),
        ),
        ChangeNotifierProvider<KeywordProvider>(
          create: (context) => KeywordProvider(),
        ),
        ChangeNotifierProvider<UserInfoProvider>(
          create: (context) => UserInfoProvider(),
        ),
        ChangeNotifierProvider<SelectingProvider>(
          create: (context) => SelectingProvider(),
        ),
        ChangeNotifierProvider<CollectionProvider>(
          create: (context) => locator<CollectionProvider>(),
        ),
        ChangeNotifierProvider<SelectionProvider>(
          create: (context) => SelectionProvider(),
        ),
        ChangeNotifierProvider<ItemProvider>(
          create: (context) => ItemProvider(),
        ),
        ChangeNotifierProvider<SearchProvider>(
          create: (context) => locator<SearchProvider>(),
        ),
      ],
      child: ScreenUtilInit(
        builder: (BuildContext context, child) => MaterialApp(
          home: MyApp(),
          debugShowCheckedModeBanner: false,
        ),
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  static final GlobalKey<_MyAppState> globalKey = GlobalKey<_MyAppState>();

  MyApp() : super(key: globalKey);

  @override
  State<MyApp> createState() => _MyAppState();
  static void restartApp() {
    globalKey.currentState?.restart();
  }
}

class _MyAppState extends State<MyApp> {
  Key _key = UniqueKey();

  void restart() {
    setState(() {
      _key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: _key,
      debugShowCheckedModeBanner: false,
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
      home: SplashScreen(),
    );
  }
}
