import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../components/button/complete_button.dart';
import '../../../components/pop_up/toast.dart';
import '../../../components/ui_kit/custom_app_bar.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/storage_service.dart';
import '../../../main.dart';

class DeleteUserScreen extends StatelessWidget {
  const DeleteUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> deleteUserWithLoadingDialog() async {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );
      try {
        await ApiService.deleteStorageFolder();
        await ApiService.cancelMembership();
        await ApiService.deleteAuthUser();
        await StorageService.deleteStorageData();
      } catch (e) {
        print('Error: $e');
      } finally {
        await Future.delayed(Duration(seconds: 1));
        if (Navigator.of(context, rootNavigator: true).canPop()) {
          Navigator.of(context, rootNavigator: true).pop();
        }
        Toast.notify('회원 탈퇴가 성공적으로 완료되었습니다.');
        MyApp.restartApp();
      }
    }

    return Scaffold(
        appBar: CustomAppbar(titleText: '회원 탈퇴'),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 24.0.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '그동안 함께해 주셔서 진심으로\n감사드립니다.',
                    style: TextStyle(
                      fontFamily: 'PretendardRegular',
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF212529),
                    ),
                  ),
                  SizedBox(
                    height: 30.0.h,
                  ),
                  Text(
                    '회원님의 소중한 의견과 관심 덕분에 저희 서비스가 성장할 수 있었습니다. 앞으로의 모든 길에 행복과 성공이 가득하시길 진심으로 응원합니다. \n\n회원 탈퇴가 완료되면, 회원님의 모든 데이터는 안전하게 삭제됩니다. 탈퇴 이후에도 언제든지 다시 찾아주시면 반갑게 맞이하겠습니다. \n\n항상 이용해 주셔서 감사합니다.',
                    style: TextStyle(
                        fontFamily: 'PretendardRegular',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF495057),
                        height: 1.43),
                  ),
                ],
              ),
              CompleteButton(
                firstFieldState: true,
                secondFieldState: true,
                onTap: () async {
                  bool? isDelete = await Toast.showConfirmationDialog(
                      context, '회원 탈퇴 하시겠습니까?');
                  if (isDelete == null) {
                    return;
                  }
                  if (isDelete) {
                    await deleteUserWithLoadingDialog();
                  }
                },
                text: '회원 탈퇴',
              ),
            ],
          ),
        ));
  }
}
