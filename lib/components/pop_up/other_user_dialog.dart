import 'package:collect_er/data/model/user_info_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../button/cancel_button.dart';
import '../ui_kit/dialog_text.dart';
import 'report_dialog.dart';
import 'toast.dart';

class OtherUserDialog extends StatelessWidget {
  final UserInfoModel userInfo;
  OtherUserDialog({super.key, required this.userInfo});

  @override
  Widget build(BuildContext context) {
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
              Toast.notify('신고가 완료되었습니다.');
            },
          );
        },
      );
    }

    void _closeDialog() {
      Navigator.pop(context);
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
                        if (isDelete) {}
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
