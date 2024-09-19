import 'package:collect_er/data/provider/collection_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../components/button/tab_bar_button.dart';
import '../../components/constants/screen_size.dart';
import '../../components/widget/collection_widget.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    initializeData();
    _tabController = TabController(length: 2, vsync: this);
    _tabController?.addListener(() {
      setState(() {
        // _currentTabIndex = _tabController?.index ?? 0;
      });
    });
  }

  Future<void> initializeData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<CollectionProvider>();
      provider.setPageChanged = 0;
      provider.getCollectionData();
    });
  }

  void _onTap(int index) {
    _tabController!.animateTo(index);
    final provider = context.read<CollectionProvider>();
    provider.setPageChanged = index;
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              automaticallyImplyLeading: false,
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
                builder: (BuildContext context, BoxConstraints constraints) {
                  return FlexibleSpaceBar(
                    expandedTitleScale: 1,
                    centerTitle: false,
                    titlePadding: EdgeInsets.zero,
                    title: Container(
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
                                tabName: 'My Collection',
                                buttonState: _tabController!.index == 0,
                              ),
                            ),
                            Tab(
                              child: TabBarButton(
                                tabName: 'Like Collection',
                                buttonState: _tabController!.index == 1,
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
                        top: ViewPaddingTopSize(context) + 20.0.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Collection',
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
                  );
                },
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            CollectionWidget(isLiked: false),
            CollectionWidget(isLiked: true),
          ],
        ),
      ),
    );
  }
}
