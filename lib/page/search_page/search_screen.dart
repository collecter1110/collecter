import 'package:collect_er/components/widget/search_collection_widget.dart';
import 'package:collect_er/data/provider/search_provider.dart';
import 'package:collect_er/data/provider/selection_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../components/button/custom_ search_bar.dart';
import '../../components/constants/screen_size.dart';
import '../../components/widget/search_category_widget.dart';
import '../../components/widget/search_selection_widget.dart';
import '../../components/widget/search_user_widget.dart';
import '../../data/provider/collection_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _doSearch(
      bool isKeyword, int categoryIndex, String? searchText) async {
    final _collectionProvider = context.read<CollectionProvider>();
    final _selectionProvider = context.read<SelectionProvider>();

    print('do search $categoryIndex');
    if (searchText != null && searchText != '') {
      if (categoryIndex == 0) {
        await _collectionProvider.getSearchCollectionData(
            searchText, isKeyword);
      } else if (categoryIndex == 1) {
        await _selectionProvider.getSearchSelectionData(searchText, isKeyword);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Selector<
            SearchProvider,
            ({
              int item1,
              bool item2,
              String? item3,
            })>(
        selector: (context, searchProvider) => (
              item1: searchProvider.selectedCategoryIndex,
              item2: searchProvider.isKeyword,
              item3: searchProvider.searchText,
            ),
        builder: (context, data, child) {
          int categoryIndex = data.item1;
          bool? isKeyword = data.item2;
          String? searchText = data.item3;

          _doSearch(isKeyword, categoryIndex, searchText);

          return Scaffold(
            resizeToAvoidBottomInset: true,
            body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    pinned: true,
                    toolbarHeight: 64.0.h,
                    expandedHeight: 140.0.h,
                    elevation: 0,
                    scrolledUnderElevation: 0,
                    foregroundColor: Colors.black,
                    titleTextStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 18.0.sp,
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      expandedTitleScale: 1,
                      centerTitle: false,
                      titlePadding: EdgeInsets.zero,
                      title: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0.h, horizontal: 16.0.w),
                        child: SearchCategoryWidget(),
                      ),
                      background: Padding(
                        padding: EdgeInsets.only(
                          left: 16.0.w,
                          right: 16.0.w,
                          top: ViewPaddingTopSize(context) + 20.0.h,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomSearchBar(
                              autoFocus: false,
                              enabled: true,
                              onSearch: () {
                                setState(() {
                                  _doSearch(
                                      isKeyword, categoryIndex, searchText);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ];
              },
              body: searchText == null
                  ? const Center(
                      child: Text('검색어를 입력해주세요.'),
                    )
                  : categoryIndex == 0
                      ? SearchCollectionWidget()
                      : categoryIndex == 1
                          ? SearchSelectionWidget(
                              routeName: '/search',
                            )
                          : categoryIndex == 2
                              ? SearchUserWidget()
                              : const Center(
                                  child: Text('해당 카테고리가 없습니다.'),
                                ),
            ),
          );
        });
  }
}
