import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/button/tab_bar_button.dart';
import '../../components/constants/screen_size.dart';
import '../../components/widget/ranking_collection_widget.dart';
import '../../components/widget/ranking_selection_widget.dart';
import '../../components/widget/ranking_user_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
    );
    _tabController?.addListener(() {
      setState(() {
        // _currentTabIndex = _tabController?.index ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  void _onTap(int index) {
    _tabController!.animateTo(index);
  }

  @override
  Widget build(BuildContext context) {
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
          body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              toolbarHeight: 64.0.h,
              expandedHeight: 120.0.h,
              elevation: 0,
              scrolledUnderElevation: 0,
              foregroundColor: Colors.black,
              titleTextStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 18.0.sp,
              ),
              flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return FlexibleSpaceBar(
                    expandedTitleScale: 1,
                    centerTitle: false,
                    titlePadding: EdgeInsets.zero,
                    title: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0.h, horizontal: 16.0.w),
                        child: TabBar(
                          controller: _tabController,
                          dividerHeight: 0,
                          indicatorColor: Colors.transparent,
                          isScrollable: true,
                          labelPadding: EdgeInsets.only(left: 0, right: 10.w),
                          tabAlignment: TabAlignment.start,
                          onTap: (value) {
                            _onTap(value);
                          },
                          tabs: [
                            Tab(
                              child: TabBarButton(
                                tabName: 'Collection',
                                buttonState: _tabController!.index == 0,
                              ),
                              height: 44.0.h,
                            ),
                            Tab(
                              child: TabBarButton(
                                tabName: 'Selection',
                                buttonState: _tabController!.index == 1,
                              ),
                              height: 44.0.h,
                            ),
                            Tab(
                              child: TabBarButton(
                                tabName: 'User',
                                buttonState: _tabController!.index == 2,
                              ),
                              height: 44.0.h,
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
                            'assets/images/image_logo_text.png',
                            width: 100.w,
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
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 18.0.w,
              ),
              child: RankingCollectionWidget(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 18.0.w,
              ),
              child: RankingSelectionWidget(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 18.0.w,
              ),
              child: RankingUserWidget(),
            ),
          ],
        ),
      )),
    );
  }
}
