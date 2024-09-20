import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/button/tab_bar_button.dart';
import '../../components/constants/screen_size.dart';
import '../../components/widget/add_collection_widget.dart';
import '../../components/widget/add_selection_widget.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                  tabName: 'Add Collection',
                                  buttonState: _tabController!.index == 0,
                                ),
                              ),
                              Tab(
                                child: TabBarButton(
                                  tabName: 'Add Selection',
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
                          top: ViewPaddingTopSize(context) + 20.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Add',
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
              AddCollectionWidget(),
              AddSelectionWidget(),
            ],
          ),
        ));
  }
}
