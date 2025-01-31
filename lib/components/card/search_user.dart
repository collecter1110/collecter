import 'package:collecter/components/widget/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/model/user_info_model.dart';
import '../../data/provider/collection_provider.dart';
import '../../page/search_page/other_user_screen.dart';

class SearchUser extends StatelessWidget {
  final String routeName;
  final UserInfoModel userInfoDetail;

  SearchUser({
    super.key,
    required this.routeName,
    required this.userInfoDetail,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final int _userId = userInfoDetail.userId!;
        context.read<CollectionProvider>().fetchUsersCollections(_userId);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                OtherUserScreen(userInfoDetail: userInfoDetail),
            settings: RouteSettings(name: routeName),
          ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AspectRatio(
            aspectRatio: 1 / 1,
            child: userInfoDetail.imageFilePath == null
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
                    storageFolderName: '${userInfoDetail.userId}/userinfo',
                    imageFilePath: userInfoDetail.imageFilePath!,
                    borderRadius: 100.0.r,
                  ),
          ),
          SizedBox(
            width: 16.0.w,
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 2.0.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    userInfoDetail.name,
                    style: TextStyle(
                      color: Color(0xFF212529),
                      fontSize: 16.sp,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700,
                      height: 1.5,
                    ),
                  ),
                  userInfoDetail.description != null
                      ? Column(
                          children: [
                            SizedBox(
                              height: 4.0.h,
                            ),
                            Text(
                              userInfoDetail.description!,
                              style: TextStyle(
                                color: Color(0xFF868E96),
                                fontSize: 12.sp,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                                height: 1.43,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        )
                      : SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
