import 'package:collecter/components/widget/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import '../../components/pop_up/other_user_dialog.dart';
import '../../components/ui_kit/custom_app_bar.dart';
import '../../components/ui_kit/expandable_text.dart';
import '../../components/widget/collection_widget.dart';
import '../../data/model/user_info_model.dart';
import '../../data/provider/user_info_provider.dart';

class OtherUserScreen extends StatelessWidget {
  final UserInfoModel userInfoDetail;
  const OtherUserScreen({
    super.key,
    required this.userInfoDetail,
  });

  @override
  Widget build(BuildContext context) {
    final String? _routeName = ModalRoute.of(context)?.settings.name;
    void _closeDialog() {
      Navigator.pop(context);
    }

    Future<void> _showDialog() async {
      final storage = FlutterSecureStorage();
      final userIdString = await storage.read(key: 'USER_ID');
      int userId = int.parse(userIdString!);
      showModalBottomSheet(
        context: context,
        isScrollControlled: false,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return userId == userInfoDetail.userId
              ? SizedBox.shrink()
              : OtherUserDialog(
                  userInfo: userInfoDetail,
                );
        },
      );
    }

    return Scaffold(
      appBar: CustomAppbar(
        titleText: 'Collecter',
        actionButtonOnTap: () async {
          await _showDialog();
        },
        actionButton: 'icon_more',
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Consumer<UserInfoProvider>(builder: (context, provider, child) {
              final String _name = userInfoDetail.name;
              final String? _description = userInfoDetail.description;
              final String? _imageFilePath = userInfoDetail.imageFilePath;

              return Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 24.0.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _imageFilePath == null
                        ? Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFe9ecef),
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/icons/tab_user.png',
                                height: 64.0.h,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : ImageWidget(
                            storageFolderName:
                                '${userInfoDetail.userId}/userinfo',
                            imageFilePath: _imageFilePath,
                            boarderRadius: 100.r,
                          ),
                    SizedBox(
                      width: 16.0.w,
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _name,
                            style: TextStyle(
                              color: Color(0xFF212529),
                              fontSize: 18.sp,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          _description != null
                              ? Column(
                                  children: [
                                    SizedBox(
                                      height: 4.0.h,
                                    ),
                                    ExpandableText(
                                      maxLine: 2,
                                      textStyle: TextStyle(
                                        color: Color(0xFF495057),
                                        fontSize: 12.sp,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w500,
                                        height: 1.43,
                                      ),
                                      text: _description,
                                    ),
                                  ],
                                )
                              : SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
            CollectionWidget(routeName: '$_routeName'),
          ],
        ),
      ),
    );
  }
}
