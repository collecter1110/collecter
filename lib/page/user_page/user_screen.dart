import 'package:collect_er/data/provider/selecting_provider.dart';
import 'package:collect_er/page/bookmark_page/bookmark_screen.dart';
import 'package:collect_er/page/user_page/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../components/button/user_page_edit_button.dart';
import '../../components/button/users_archive_button.dart';
import '../../components/constants/screen_size.dart';
import '../../components/ui_kit/expandable_text.dart';
import '../../data/provider/collection_provider.dart';
import '../../data/provider/user_info_provider.dart';
import '../../data/services/data_management.dart';
import '../../data/services/locator.dart';
import '../../data/services/storage_service.dart';
import 'selecting_screen.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  void initState() {
    super.initState();
    initializeData();
  }

  void initializeData() async {
    final provider = context.read<UserInfoProvider>();
    await provider.getUsersData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: 16.0.w,
            right: 16.0.w,
            top: ViewPaddingTopSize(context) + 20.0.h,
          ),
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
                onTap: () {},
                child: Image.asset(
                  'assets/icons/icon_hamburger.png',
                  height: 20.0.h,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0.w,
                ),
                child: Column(
                  children: [
                    Consumer<UserInfoProvider>(
                      builder: (context, provider, child) {
                        if (provider.state == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (provider.state == ConnectionState.done) {
                          final int _userId = provider.userInfo!.userId;
                          final String _name = provider.userInfo!.name;
                          final String? _description =
                              provider.userInfo?.description;
                          final String? _imageFilePath =
                              provider.userInfo?.imageFilePath;

                          return Padding(
                            padding:
                                EdgeInsets.only(top: 36.0.h, bottom: 20.0.h),
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
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                          border: Border.all(
                                            color: Color(0xFFdee2e6),
                                            width: 0.5.w,
                                          ),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              StorageService.getFullImageUrl(
                                                  '${_userId}/userinfo',
                                                  _imageFilePath),
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                SizedBox(
                                  width: 16.0.w,
                                ),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                        } else {
                          return const Center(
                            child: Text('Error occurred.'),
                          );
                        }
                      },
                    ),
                    Padding(
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
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0.h),
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
                  ],
                ),
              ),
              Container(
                height: 12.0.h,
                color: Color(0xFFf5f5f5),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.0.w),
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    primary: false,
                    scrollDirection: Axis.vertical,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      final List<String> _name = ['공지사항', '문의사항', '설정'];
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.0.h),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                            onTap: () {},
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 14.0.h),
                              child: Text(
                                _name[index],
                                style: TextStyle(
                                  fontFamily: 'PretendardRegular',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        color: Color(0xFFf1f3f5),
                        thickness: 1.0,
                        height: 0,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
