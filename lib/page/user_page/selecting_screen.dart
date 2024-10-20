import 'package:collect_er/components/widget/selecting_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../components/button/tab_bar_button.dart';
import '../../components/ui_kit/custom_app_bar.dart';
import '../../data/provider/selecting_provider.dart';

class SelectingScreen extends StatefulWidget {
  final int initialPageIndex;
  const SelectingScreen({
    super.key,
    required this.initialPageIndex,
  });

  @override
  State<SelectingScreen> createState() => _UsersSelectScreenState();
}

class _UsersSelectScreenState extends State<SelectingScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  @override
  void initState() {
    super.initState();
    initializeData();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialPageIndex,
    );
    _tabController!.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (_tabController!.indexIsChanging) {
      setState(() {});
    }
  }

  void initializeData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<SelectingProvider>();
      provider.setPageChanged = widget.initialPageIndex;
    });
  }

  void _onTap(int index) {
    _tabController!.animateTo(index);
    final provider = context.read<SelectingProvider>();
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
      appBar: CustomAppbar(
        titleText: '나의 셀렉트',
        actionButtonOnTap: () {},
      ),
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
                    child: TabBarButton(
                      tabName: 'Selecting',
                      buttonState: _tabController!.index == 0,
                    ),
                  ),
                  Tab(
                    child: TabBarButton(
                      tabName: 'Selected',
                      buttonState: _tabController!.index == 1,
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
                SelectingWidget(
                  isSelected: false,
                ),
                SelectingWidget(
                  isSelected: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
