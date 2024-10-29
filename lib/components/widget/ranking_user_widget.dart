import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/model/user_info_model.dart';
import '../../data/provider/ranking_provider.dart';
import '../card/search_user.dart';

class RankingUserWidget extends StatelessWidget {
  const RankingUserWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<RankingProvider>(builder: (context, provider, child) {
      final List<UserInfoModel>? _users;

      _users = provider.rankingUsers;

      if (provider.state == ConnectionState.waiting) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (provider.state == ConnectionState.done) {
        return (_users != null && _users.isNotEmpty)
            ? GridView.builder(
                padding: EdgeInsets.symmetric(
                  vertical: 22.0.h,
                ),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 16.0.h,
                  childAspectRatio: 6,
                ),
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  final UserInfoModel _user = _users![index];
                  return SearchUser(
                    routeName: '/',
                    userInfoDetail: _user,
                  );
                },
              )
            : Center(
                child: Text(
                  'collecter 의 첫번째 유저가 되어보세요!',
                  style: TextStyle(
                    color: Color(0xFF868e96),
                    fontSize: 14.sp,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
      } else {
        return const Center(
          child: Text('Error occurred.'),
        );
      }
    });
  }
}
