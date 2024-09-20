import 'package:collect_er/data/model/user_info_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchUser extends StatelessWidget {
  final UserInfoModel userInfoDetail;

  SearchUser({
    super.key,
    required this.userInfoDetail,
  });
  String? collectionTitle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFe9ecef),
            ),
            child: ClipOval(
              child: userInfoDetail.imageFilePath == null
                  ? Image.asset(
                      'assets/icons/tab_user.png',
                      height: 50.0.h,
                      color: Colors.white,
                    )
                  : SizedBox.shrink(),
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
