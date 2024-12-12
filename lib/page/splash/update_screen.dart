import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/pop_up/toast.dart';
import '../../components/widget/splash_widget.dart';
import '../../data/services/storage_service.dart';

class UpdateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (BuildContext context, child) => MaterialApp(
        home: UpdateScreenWidget(),
        debugShowCheckedModeBanner: false,
      ),
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
    );
  }
}

class UpdateScreenWidget extends StatefulWidget {
  const UpdateScreenWidget({Key? key}) : super(key: key);

  @override
  State<UpdateScreenWidget> createState() => _UpdateScreenWidgetState();
}

class _UpdateScreenWidgetState extends State<UpdateScreenWidget> {
  @override
  void initState() {
    super.initState();
    _getAccessToken(context);
  }

  Future<void> _getAccessToken(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Toast.showUpdateDialog(context);
      await StorageService.deleteStorageData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SplashWidget();
  }
}
