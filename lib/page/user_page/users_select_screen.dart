import 'package:collect_er/components/widget/select_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/button/category_button.dart';
import '../../components/ui_kit/custom_app_bar.dart';

class UsersSelectScreen extends StatefulWidget {
  final int initialPageIndex;
  const UsersSelectScreen({
    super.key,
    required this.initialPageIndex,
  });

  @override
  State<UsersSelectScreen> createState() => _UsersSelectScreenState();
}

class _UsersSelectScreenState extends State<UsersSelectScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 2, vsync: this, initialIndex: widget.initialPageIndex);
    _tabController?.addListener(() {
      setState(() {
        // _currentTabIndex = _tabController?.index ?? 0;
      });
    });
  }

  void _onTap(int index) {
    _tabController!.animateTo(index);
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
          popState: true,
          titleText: '나의 셀렉트',
          titleState: true,
          actionButtonOnTap: () {},
          actionButton: null),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Padding(
              padding:
                  EdgeInsets.symmetric(vertical: 10.0.h, horizontal: 16.0.w),
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
                    child: CategoryButton(
                      categoryName: 'Selecting',
                      categoryState: _tabController!.index == 0,
                    ),
                  ),
                  Tab(
                    child: CategoryButton(
                      categoryName: 'Selected',
                      categoryState: _tabController!.index == 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                SelectWidget(
                  isSelecting: true,
                ),
                SelectWidget(
                  isSelecting: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
