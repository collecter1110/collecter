import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/button/category_button.dart';

import '../../components/constants/screen_size.dart';
import '../../components/card/ranking_collection.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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

    final double _selectionRatio = 0.8;
    final double _collectionRatio = 2.4;
    return PopScope(
      canPop: true,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          print('didPop호출');
          return;
        }
        print('뒤로가기');
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              toolbarHeight: 64.0.h,
              expandedHeight: 130.0,
              elevation: 0,
              scrolledUnderElevation: 0,
              foregroundColor: Colors.black,
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
                    background: Padding(
                      padding: EdgeInsets.only(
                        left: 16.0.w,
                        right: 16.0.w,
                        top: ViewPaddingTopSize(context) + 20.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/image_logo.png',
                            width: 100,
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
                      padding: EdgeInsets.only(top: 12.0.h, bottom: 4.0.h),
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
              padding:
                  EdgeInsets.symmetric(horizontal: 18.0.w, vertical: 20.0.h),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Column(
                    children: [
                      RankingCollection(
                        index: index,
                        ratio: _collectionRatio,
                      )
                    ],
                  ),
                  childCount: _name.length,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 14.0.h,
                  crossAxisSpacing: 10.0.w,
                  childAspectRatio: _collectionRatio,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
