import 'package:collect_er/data/model/user_info_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/provider/user_info_provider.dart';
import '../card/search_user.dart';

class SearchUserWidget extends StatelessWidget {
  const SearchUserWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserInfoProvider>(builder: (context, provider, child) {
      List<UserInfoModel>? _users = provider.searchUsers;
      if (provider.state == ConnectionState.waiting) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (provider.state == ConnectionState.done) {
        return _users!.isNotEmpty
            ? GridView.builder(
                padding:
                    EdgeInsets.symmetric(vertical: 22.0.h, horizontal: 16.0.w),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 16.0.h,
                  childAspectRatio: 6,
                ),
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  final UserInfoModel _userInfoDetail = _users[index];
                  return SearchUser(
                    userInfoDetail: _userInfoDetail,
                  );
                },
              )
            : const Center(
                child: Text('일치하는 데이터가 없습니다.'),
              );
      } else {
        return const Center(
          child: Text('Error occurred.'),
        );
      }
    });
  }
}
