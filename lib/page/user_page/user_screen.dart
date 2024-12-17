import 'package:collecter/data/model/user_info_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../components/button/tab_bar_button.dart';
import '../../components/button/user_page_edit_button.dart';
import '../../components/button/users_archive_button.dart';
import '../../components/constants/screen_size.dart';
import '../../components/ui_kit/expandable_text.dart';
import '../../components/widget/image_widget.dart';
import '../../components/widget/like_widget.dart';
import '../../data/provider/collection_provider.dart';
import '../../data/provider/selecting_provider.dart';
import '../../data/provider/user_info_provider.dart';
import '../../data/services/locator.dart';
import '../bookmark_page/bookmark_screen.dart';
import 'edit_profile_screen.dart';
import 'selecting_screen.dart';
import 'setting_screen.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: ViewPaddingTopSize(context) + 20.0.h,
                bottom: 20.0.h,
                left: 18.0.w,
                right: 18.0.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'My Page',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 18.0.sp,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingScreen(),
                        settings: RouteSettings(name: '/user'),
                      ),
                    );
                  },
                  child: Image.asset(
                    'assets/icons/icon_hamburger.png',
                    height: 20.0.h,
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.0.w),
                    child: Consumer<UserInfoProvider>(
                        builder: (context, provider, child) {
                      final UserInfoModel? _userInfo = provider.userInfo;
                      if (_userInfo == null) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        final int _userId = _userInfo!.userId;
                        final String _name = _userInfo!.name;
                        final String? _description = _userInfo.description;
                        final String? _imageFilePath = _userInfo.imageFilePath;

                        return Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 6.0.h,
                          ),
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
                                  : Container(
                                      width: 80.0.w,
                                      height: 80.0.w,
                                      child: ImageWidget(
                                        storageFolderName:
                                            '${_userId}/userinfo',
                                        imageFilePath: _imageFilePath,
                                        borderRadius: 100.r,
                                      ),
                                    ),
                              SizedBox(
                                width: 16.0.w,
                              ),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                      }
                    }),
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 50.0.w, vertical: 20.0.h),
                      child: Consumer<SelectingProvider>(
                          builder: (context, provider, child) {
                        // final int? collectionNum = provider.collectionNum;
                        final int _selectingNum = provider.selectingNum;
                        final int _selectedNum = provider.selectedNum;

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            UsersArchiveButton(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookmarkScreen(),
                                    settings: RouteSettings(name: '/bookmark'),
                                  ),
                                );
                              },
                              number:
                                  locator<CollectionProvider>().collectionNum,
                              name: 'Collection',
                            ),
                            UsersArchiveButton(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SelectingScreen(
                                      initialPageIndex: 0,
                                    ),
                                    settings: RouteSettings(name: '/user'),
                                  ),
                                );
                              },
                              number: _selectingNum,
                              name: 'Selecting',
                            ),
                            UsersArchiveButton(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SelectingScreen(
                                      initialPageIndex: 1,
                                    ),
                                    settings: RouteSettings(name: '/user'),
                                  ),
                                );
                              },
                              number: _selectedNum,
                              name: 'Selected',
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 20.0.h, horizontal: 18.0.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        UserPageEditButton(
                            name: '프로필 편집',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfileScreen(),
                                  settings: RouteSettings(name: '/user'),
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                  Container(
                    height: 12.0.h,
                    color: Color(0xFFf8f9fa),
                  ),
                  SizedBox(
                    height: 10.0.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 18.0.w, vertical: 10.0.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/icons/icon_heart_fill.png',
                          fit: BoxFit.contain,
                          height: 12.0.h,
                        ),
                        SizedBox(
                          width: 8.0.w,
                        ),
                        Text(
                          '좋아요 리스트',
                          style: TextStyle(
                            color: Color(0xFF343A40),
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.0.w),
                    child: Divider(height: 0.5.h, color: Color(0xFFe9ecef)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 18.0.w, right: 18.0.w, top: 10.0.h),
                    child: TabBarButton(
                      tabName: 'Collection',
                      buttonState: true,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.0.w),
                    child: LikeWidget(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
