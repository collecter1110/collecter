import 'package:collect_er/page/bookmark_page/bookmark_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../components/button/user_page_edit_button.dart';
import '../../components/button/users_archive_button.dart';
import '../../components/constants/screen_size.dart';
import '../../components/ui_kit/collection_tag.dart';
import '../../data/provider/user_info_provider.dart';
import 'users_select_screen.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<int> _usersTagList = [
      0,
      1,
      2,
      // 3,
      // 4,
      // 5,
      // 6,
      // 7,
      // 8,
      // 9,
      // 10,
    ];

    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 130.0.h,
          child: Padding(
            padding: EdgeInsets.only(
              left: 16.0.w,
              right: 16.0.w,
              top: ViewPaddingTopSize(context) + 20.0.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    Navigator.of(context).pushNamed('/search');
                  },
                  child: Image.asset(
                    'assets/icons/tab_search.png',
                    height: 20.0.h,
                  ),
                ),
              ],
            ),
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
                child: Consumer<UserInfoProvider>(
                    builder: (context, provider, child) {
                  provider.fetchUserInfo();

                  if (provider.userInfo == null) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final String _name = provider.userInfo!.name;
                  final String _description = provider.userInfo!.description;
                  final String _imageUrl = provider.userInfo!.imageUrl;
                  final int _userId = provider.userInfo!.userId;

                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 6.0.h),
                            child: Text(
                              _name,
                              style: TextStyle(
                                color: Color(0xFF212529),
                                fontSize: 18.sp,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w700,
                                height: 1.5.h,
                              ),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Wrap(
                                alignment: WrapAlignment.start,
                                runSpacing: 8.0.h,
                                spacing: 10.0.w,
                                children: _usersTagList.map((index) {
                                  return CollectionTag.getTag(index);
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 50.0.w, vertical: 18.0.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            UsersArchiveButton(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookmarkScreen(),
                                  ),
                                );
                              },
                              number: 0,
                              name: 'Collection',
                            ),
                            UsersArchiveButton(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UsersSelectScreen(
                                      initialPageIndex: 0,
                                    ),
                                  ),
                                );
                              },
                              number: 0,
                              name: 'Selecting',
                            ),
                            UsersArchiveButton(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UsersSelectScreen(
                                      initialPageIndex: 1,
                                    ),
                                  ),
                                );
                              },
                              number: 0,
                              name: 'Selected',
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            UserPageEditButton(name: '프로필 보기', onTap: () {}),
                            SizedBox(
                              width: 6.0.w,
                            ),
                            UserPageEditButton(name: '태그보기', onTap: () {})
                          ],
                        ),
                      ),
                    ],
                  );
                }),
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
