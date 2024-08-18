import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/button/category_button.dart';
import '../../components/constants/screen_size.dart';
import '../../components/ui_kit/collect.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> _name = [
      '나만의 레시피북',
      '다이어트 레시피',
      '여름 코디룩',
      '사고 싶은 화장품 리스트',
      '저소음 기계식 키보드 리스트',
      '읽은 책 목록',
      '읽고 싶은 책 목록',
    ];

    List<String> _titleName = [
      '화제의 컬랙션 랭킹',
      '많이 검색한 키워드',
      '팔로우 많은 유저 랭킹',
    ];
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            toolbarHeight: 64.0.h,
            expandedHeight: 104.0.h + ViewPaddingTopSize(context),
            elevation: 0,
            scrolledUnderElevation: 0,
            foregroundColor: Colors.black, // 기본 스크롤 위치에서의 색상
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 18.0.sp,
            ),
            //collapsedBackgroundColor: Colors.red, // 스크롤 시 타이틀 색상
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return FlexibleSpaceBar(
                  expandedTitleScale: 1,
                  centerTitle: true,
                  titlePadding: EdgeInsets.zero,
                  title: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0.h, horizontal: 16.0.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {},
                            child: CategoryButton(
                              categoryName: 'Collection',
                              categoryState: false,
                            ),
                          ),
                          SizedBox(
                            width: 8.0.w,
                          ),
                          InkWell(
                            onTap: () {},
                            child: CategoryButton(
                              categoryName: 'Keyword',
                              categoryState: true,
                            ),
                          ),
                          SizedBox(
                            width: 8.0.w,
                          ),
                          InkWell(
                            onTap: () {},
                            child: CategoryButton(
                              categoryName: 'User',
                              categoryState: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  background: Container(
                      color: Color(0xFF292a29),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 20.0.h,
                              child: Image.asset(
                                'assets/images/image_logo.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(
                              height: 20.0.h,
                              child: Image.asset(
                                'assets/icons/tab_search.png',
                                fit: BoxFit.contain,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      )),
                );
              },
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 18.0.w),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(
                    height: 34.0.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '화제의 컬렉션 랭킹',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 18.0.sp,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 12.0.h, bottom: 24.0.h),
                    child: Divider(
                      color: Colors.black,
                      thickness: 2.0.h,
                      height: 0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 18.0.w),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Column(
                  children: [
                    Collect(),
                  ],
                ),
                childCount: _name.length,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 그리드의 열 개수를 설정하세요
                mainAxisSpacing: 10.0.h, // 위아래 간격
                crossAxisSpacing: 15.0.w, // 좌우 간격
                childAspectRatio: 0.7, // 항목의 가로세로 비율을 설정하세요
              ),
            ),
          )
        ],
      ),
    );
  }
}
