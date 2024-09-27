import 'package:collect_er/components/widget/collection_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../components/ui_kit/custom_app_bar.dart';
import '../../components/ui_kit/expandable_text.dart';
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
    return Scaffold(
      appBar: CustomAppbar(
          titleText: 'User', actionButtonOnTap: () {}, actionButton: null),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Consumer<UserInfoProvider>(builder: (context, provider, child) {
              // provider.getUsersData();

              // if (provider.sea == null) {
              //   return Center(child: CircularProgressIndicator());
              // }
              final String _name = userInfoDetail.name;
              final String? _description = userInfoDetail.description;
              final String? _imageUrl = userInfoDetail.imageFilePath;

              return Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 24.0.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
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
            CollectionWidget(),
          ],
        ),
      ),
    );
  }
}
