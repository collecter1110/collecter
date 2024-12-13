import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/button/category_button.dart';
import '../../components/button/tab_bar_button.dart';
import '../../components/constants/screen_size.dart';
import '../../components/widget/collection_widget.dart';
import '../add_page/add_screen.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    _tabController?.addListener(() {
      setState(() {
        // _currentTabIndex = _tabController?.index ?? 0;
      });
    });
  }

  Future<void> _onTap(int index) async {
    _tabController!.animateTo(index);
    setState(() {
      _selectedCategoryId = null;
    });
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
              toolbarHeight: 100.0.h,
              expandedHeight: 160.0.h,
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TabBar(
                            controller: _tabController,
                            dividerHeight: 0,
                            indicatorColor: Colors.transparent,
                            isScrollable: true,
                            labelPadding: EdgeInsets.only(
                              left: 18.0.w,
                            ),
                            tabAlignment: TabAlignment.start,
                            onTap: (value) async {
                              await _onTap(value);
                            },
                            tabs: [
                              Tab(
                                child: TabBarButton(
                                  tabName: 'My Collection',
                                  buttonState: _selectedCategoryId == null,
                                ),
                                height: 44.0.h,
                              ),
                            ],
                          ),
                          Container(
                            height: 50.0.h,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.0.h),
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                padding:
                                    EdgeInsets.symmetric(horizontal: 18.0.h),
                                shrinkWrap: true,
                                primary: true,
                                // physics: const NeverScrollableScrollPhysics(),
                                itemCount: 9,
                                itemBuilder: (context, index) {
                                  return CategoryButton(
                                    categoryId: index,
                                    selectedCategoryId: _selectedCategoryId,
                                    onTap: (value) {
                                      setState(() {
                                        _selectedCategoryId = value;
                                      });
                                    },
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return SizedBox(
                                    width: 12.0.w,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddScreen(),
                                  settings: RouteSettings(name: '/add'),
                                ),
                              );
                            },
                            child: Image.asset(
                              'assets/icons/icon_plus_light.png',
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
            CollectionWidget(
              isLiked: false,
              routeName: '/bookmark',
              categoryId: _selectedCategoryId,
            ),
          ],
        ),
      ),
    );
  }
}
