import 'package:collect_er/data/model/user_info_model.dart';
import 'package:collect_er/data/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/services/data_service.dart';
import '../button/cancel_button.dart';
import '../ui_kit/dialog_text.dart';
import 'report_dialog.dart';
import 'toast.dart';

class OtherUserDialog extends StatelessWidget {
  final UserInfoModel userInfo;
  OtherUserDialog({super.key, required this.userInfo});

  @override
  Widget build(BuildContext context) {
    void _closeDialog() {
      Navigator.pop(context);
    }

    Future<void> showLoadingDialog() async {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );
      try {
        await ApiService.block(userInfo.userId);
        await DataService.reloadSearchData();
      } catch (e) {
        print('Error: $e');
      } finally {
        if (Navigator.of(context, rootNavigator: true).canPop()) {
          Navigator.of(context, rootNavigator: true).pop();
        }
        _closeDialog();
        Navigator.pop(context);
        Toast.notify('유저가 차단되었습니다.');
      }
    }

    Future<void> _showReportDialog() async {
      showModalBottomSheet(
        context: context,
        isScrollControlled: false,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return ReportDialog(
            reportType: 0,
            userId: userInfo.userId,
            voidCallback: () async {
              Toast.notify('신고가 완료되었습니다.\n24시간 내에 처리될 예정입니다.');
            },
          );
        },
      );
    }

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(12.0.r),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    DialogText(
                      text: '신고하기',
                      textColor: Colors.red,
                      onTap: () async {
                        await _showReportDialog();
                      },
                    ),
                    Divider(height: 0.5.h, color: Color(0xFFe9ecef)),
                    DialogText(
                      text: '차단하기',
                      textColor: Colors.black,
                      onTap: () async {
                        bool? isDelete = await Toast.showConfirmationDialog(
                            context, '해당 유저를 차단하시겠습니까?');
                        if (isDelete == null) {
                          return;
                        }
                        if (isDelete) {
                          showLoadingDialog();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 16.0.w, right: 16.0.w, top: 12.0.h, bottom: 20.0.h),
              child: CancelButton(),
            ),
          ],
        );
      },
    );
  }
}
