import 'package:collect_er/components/widget/search_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/button/custom_ search_bar.dart';
import '../../components/button/sub_category_button.dart';
import '../../components/constants/screen_size.dart';
import '../../components/widget/search_category_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController?.addListener(() {
      setState(() {});
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

  bool isSelected = true;
  @override
  Widget build(BuildContext context) {
    return

        // Scaffold(
        //   body: Padding(
        //     padding: EdgeInsets.only(
        //       top: ViewPaddingTopSize(context) + 20.0.w,
        //       left: 16.0.w,
        //       right: 16.0.w,
        //     ),
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.start,
        //       children: [

        //       Padding(
        //         padding: EdgeInsets.symmetric(vertical: 18.0.h),
        //         child: const Align(
        //           alignment: Alignment.centerLeft,
        //           child: Text(
        //             '최근 검색',
        //             style: TextStyle(
        //               color: Color(0xFF343A40),
        //               fontSize: 16,
        //               fontFamily: 'Pretendard',
        //               fontWeight: FontWeight.w600,
        //               height: 1.5,
        //             ),
        //           ),
        //         ),
        //       ),

        //       Expanded(
        //         child: ListView.separated(
        //           scrollDirection: Axis.vertical,
        //           itemCount: interests.length,
        //           padding: EdgeInsets.symmetric(vertical: 10.0.h),
        //           itemBuilder: (context, index) {
        //             return GestureDetector(
        //               onTap: () {},
        //               child: Row(
        //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                 children: [
        //                   Text(
        //                     interests[index],
        //                     style: TextStyle(
        //                       fontSize: 16.0.sp,
        //                       color: Colors.black,
        //                       fontWeight: FontWeight.w500,
        //                     ),
        //                   ),
        //                   IconButton(
        //                     icon: Image.asset(
        //                       'assets/icons/button_delete.png',
        //                       height: 12.0,
        //                     ),
        //                     onPressed: () {
        //                       interests.removeAt(index);
        //                     },
        //                   )
        //                 ],
        //               ),
        //             );
        //           },
        //           separatorBuilder: (BuildContext context, int index) {
        //             return Container(
        //               height: 2.0.h,
        //             );
        //           },
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        Scaffold(
      resizeToAvoidBottomInset: true,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
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
                builder: (BuildContext context, BoxConstraints constraints) {
                  return FlexibleSpaceBar(
                    expandedTitleScale: 1,
                    centerTitle: false,
                    titlePadding: EdgeInsets.zero,
                    title: Container(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0.h, horizontal: 16.0.w),
                        // child: TabBar(
                        //   controller: _tabController,
                        //   dividerHeight: 0,
                        //   indicatorColor: Colors.transparent,
                        //   isScrollable: true,
                        //   labelPadding:
                        //       EdgeInsets.only(left: 0, right: 10.w),
                        //   tabAlignment: TabAlignment.start,
                        //   onTap: (value) {
                        //     _onTap(value);
                        //   },
                        //   tabs: [
                        //     Tab(
                        //       child: SearchCategoryButton(
                        //         categoryName: 'Keyword',
                        //         buttonState: _tabController!.index == 0,
                        //       ),
                        //     ),
                        //     Tab(
                        //       child: SearchCategoryButton(
                        //         categoryName: 'Tag',
                        //         buttonState: _tabController!.index == 1,
                        //       ),
                        //     ),
                        //     Tab(
                        //       child: SearchCategoryButton(
                        //         categoryName: 'User',
                        //         buttonState: _tabController!.index == 2,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        child: SearchCategoryWidget(),
                      ),
                    ),
                    background: Padding(
                      padding: EdgeInsets.only(
                        left: 16.0.w,
                        right: 16.0.w,
                        top: ViewPaddingTopSize(context) + 20.0,
                      ),
                      child: CustomSearchBar(
                        autoFocus: false,
                        enabled: true,
                        onSearch: (String value) {
                          setState(() {});
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ];
        },
        body: Container(),
      ),
    );
  }
}
