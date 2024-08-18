import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/button/custom_ search_bar.dart';
import '../../components/constants/screen_size.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<String> interests = [
    '유어프레소',
    '메시',
    '언덕',
    '강북성북고용복지플러스센터',
    '중앙감속기',
    '봉쥬르',
    '성수동간판없는집',
    '성수노루',
    '금금',
    '유어프레소',
    '메시',
    '언덕',
    '강북성북고용복지플러스센터',
    '중앙감속기',
    '봉쥬르',
    '성수동간판없는집',
    '성수노루',
    '금금',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: ViewPaddingTopSize(context) + 20.0.w,
          left: 16.0.w,
          right: 16.0.w,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomSearchBar(
              autoFocus: false,
              enabled: true,
              onSearch: (String value) {
                setState(() {});
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 18.0.h),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '최근 검색',
                  style: TextStyle(
                    color: Color(0xFF343A40),
                    fontSize: 16,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                scrollDirection: Axis.vertical,
                itemCount: interests.length,
                padding: EdgeInsets.symmetric(vertical: 10.0.h),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          interests[index],
                          style: TextStyle(
                            fontSize: 16.0.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        IconButton(
                          icon: Image.asset(
                            'assets/icons/button_delete.png',
                            height: 12.0,
                          ),
                          onPressed: () {
                            interests.removeAt(index);
                          },
                        )
                      ],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 2.0.h,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
