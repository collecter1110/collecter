import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/constants/screen_size.dart';
import '../../components/ui_kit/collection_tag.dart';

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
      children: [
        Container(
          height: 130.0,
          child: Padding(
            padding: EdgeInsets.only(
              left: 16.0.w,
              right: 16.0.w,
              top: ViewPaddingTopSize(context) + 20.0,
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
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(200),
                            color: Color(0xFFe9ecef),
                          ),
                          child: Image.asset(
                            'assets/icons/tab_user.png',
                            height: 64.0.h,
                            width: 64.0.w,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 16.0.w,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 6.0.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'coffeeco',
                                style: TextStyle(
                                  color: Color(0xFF212529),
                                  fontSize: 18.sp,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w700,
                                  height: 1.5.h,
                                ),
                              ),
                              SizedBox(
                                width: 10.0.w,
                              ),
                            ],
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
                          Column(
                            children: [
                              Text(
                                '0',
                                style: TextStyle(
                                  color: Color(0xFF212529),
                                  fontSize: 16.sp,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w700,
                                  height: 1.5,
                                ),
                              ),
                              Text(
                                'Collection',
                                style: TextStyle(
                                  color: Color(0xFF212529),
                                  fontSize: 12.sp,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w500,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '0',
                                style: TextStyle(
                                  color: Color(0xFF212529),
                                  fontSize: 16.sp,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w700,
                                  height: 1.5,
                                ),
                              ),
                              Text(
                                'Selecting',
                                style: TextStyle(
                                  color: Color(0xFF212529),
                                  fontSize: 12.sp,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w500,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '0',
                                style: TextStyle(
                                  color: Color(0xFF212529),
                                  fontSize: 16.sp,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w700,
                                  height: 1.5,
                                ),
                              ),
                              Text(
                                'Selected',
                                style: TextStyle(
                                  color: Color(0xFF212529),
                                  fontSize: 12.sp,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w500,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                minimumSize: Size.zero,
                                padding: EdgeInsets.symmetric(
                                  vertical: 6.0.h,
                                ),
                                backgroundColor: Color(0xFFdee2e6),
                                elevation: 0,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                '프로필 편집',
                                style: TextStyle(
                                  fontFamily: 'PretendardRegular',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  height: 1.43,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 6.0.w,
                          ),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                minimumSize: Size.zero,
                                padding: EdgeInsets.symmetric(
                                  vertical: 6.0.h,
                                ),
                                backgroundColor: Color(0xFFdee2e6),
                                elevation: 0,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                '태그 보기',
                                style: TextStyle(
                                  fontFamily: 'PretendardRegular',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  height: 1.43,
                                ),
                              ),
                            ),
                          ),
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
