import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/model/collection_model.dart';
import '../../data/model/user_info_model.dart';
import '../../data/provider/collection_provider.dart';
import '../../data/provider/user_info_provider.dart';
import '../../page/search_page/other_user_screen.dart';
import '../button/cancel_button.dart';
import '../ui_kit/dialog_text.dart';
import 'report_dialog.dart';
import 'toast.dart';

class OtherCollectionDialog extends StatelessWidget {
  final String routeName;
  final CollectionModel collectionDetail;
  OtherCollectionDialog({
    super.key,
    required this.routeName,
    required this.collectionDetail,
  });

  @override
  Widget build(BuildContext context) {
    void _closeDialog() {
      Navigator.pop(context);
    }

    Future<void> _showReportDialog() async {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return ReportDialog(
            reportType: 1,
            collectionId: collectionDetail.id,
            voidCallback: () async {
              _closeDialog();
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
                      text: '유저 정보',
                      textColor: Colors.black,
                      onTap: () async {
                        final int _userId = collectionDetail.userId;
                        final _userInfoProvider =
                            context.read<UserInfoProvider>();
                        await _userInfoProvider.fetchOtherUserInfo(_userId);
                        await context
                            .read<CollectionProvider>()
                            .getSearchUsersCollectionData(_userId);
                        UserInfoModel _userInfo =
                            _userInfoProvider.otherUserInfo!;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                OtherUserScreen(userInfoDetail: _userInfo),
                            settings: RouteSettings(name: '$routeName'),
                          ),
                        );
                      },
                    ),
                    Divider(height: 0.5.h, color: Color(0xFFe9ecef)),
                    DialogText(
                      text: '신고하기',
                      textColor: Colors.red,
                      onTap: () async {
                        await _showReportDialog();
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
