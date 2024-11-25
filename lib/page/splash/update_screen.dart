import 'package:flutter/material.dart';

import '../../components/pop_up/toast.dart';
import '../../components/widget/splash_widget.dart';
import '../../data/services/storage_service.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({Key? key}) : super(key: key);

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
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
