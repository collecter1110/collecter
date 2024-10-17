import 'package:collect_er/data/provider/collection_provider.dart';
import 'package:collect_er/data/provider/ranking_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../components/button/tab_bar_button.dart';

import '../../components/constants/screen_size.dart';
import '../../components/card/ranking_collection.dart';
import '../../components/widget/ranking_collection_widget.dart';
import '../../components/widget/search_collection_widget.dart';
import '../../components/widget/selection_widget.dart';
import '../../components/widget/user_widget.dart';

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
        initialIndex: context.read<RankingProvider>().selectedCategoryIndex);
    _tabController?.addListener(() {
      setState(() {
        // _currentTabIndex = _tabController?.index ?? 0;
      });
    });
    initializeRankingData();
  }

  void initializeRankingData() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final collectionProvider = context.read<CollectionProvider>();
      await collectionProvider.getRankingCollectionData();
    });
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  void _onTap(int index) {
    _tabController!.animateTo(index);
    final _rankingProvider = context.read<RankingProvider>();
    _rankingProvider.setCategoryIndex = index;
  }

  Future<void> _getRankingData(
    int categoryIndex,
  ) async {
    final _collectionProvider = context.read<CollectionProvider>();
    // final _selectionProvider = context.read<SelectionProvider>();
    // final _userProvider = context.read<UserInfoProvider>();

    print('get ranking data $categoryIndex');

    switch (categoryIndex) {
      case 0:
        await _collectionProvider.getRankingCollectionData();

        break;

      case 1:
        // await _selectionProvider.getSearchSelectionData(searchText);
        break;

      case 2:
        // await _userProvider.getSearchUsers(searchText);
        break;

      default:
        break;
    }
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
        child: Selector<RankingProvider, ({int item1})>(
            selector: (context, searchProvider) =>
                (item1: searchProvider.selectedCategoryIndex,),
            builder: (context, data, child) {
              int _categoryIndex = data.item1;
              print(_categoryIndex);
              return Scaffold(
                  body: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      pinned: true,
                      toolbarHeight: 64.0.h,
                      expandedHeight: 130.0.h,
                      elevation: 0,
                      scrolledUnderElevation: 0,
                      foregroundColor: Colors.black,
                      titleTextStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 18.0.sp,
                      ),
                      flexibleSpace: LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
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
                                  labelPadding:
                                      EdgeInsets.only(left: 0, right: 10.w),
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
                                    ),
                                    Tab(
                                      child: TabBarButton(
                                        tabName: 'Selection',
                                        buttonState: _tabController!.index == 1,
                                      ),
                                    ),
                                    Tab(
                                      child: TabBarButton(
                                        tabName: 'User',
                                        buttonState: _tabController!.index == 2,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    'assets/images/image_logo.png',
                                    width: 100,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context)
                                          .pushNamed('/search');
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
                // SliverPadding(
                //   padding: EdgeInsets.symmetric(horizontal: 18.0.w),
                //   sliver: SliverToBoxAdapter(
                //     child: Column(
                //       children: [
                //         SizedBox(
                //           height: 34.0.h,
                //         ),
                //         Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: [
                //             Text(
                //               '화제의 컬렉션 랭킹',
                //               style: TextStyle(
                //                 color: Colors.black,
                //                 fontWeight: FontWeight.w700,
                //                 fontSize: 18.0.sp,
                //               ),
                //             ),
                //           ],
                //         ),
                //         Padding(
                //           padding: EdgeInsets.only(top: 12.0.h, bottom: 4.0.h),
                //           child: Divider(
                //             color: Colors.black,
                //             thickness: 2.0.h,
                //             height: 0,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),

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
                      child: SelectionWidget(
                        routeName: '/',
                        collectionId: 0,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 18.0.w,
                      ),
                      child: UserWidget(),
                    ),
                  ],
                ),
              ));
            }));
  }
}
