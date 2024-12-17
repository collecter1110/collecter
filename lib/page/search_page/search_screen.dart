import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../components/button/custom_ search_bar.dart';
import '../../components/constants/screen_size.dart';
import '../../components/widget/search_category_widget.dart';
import '../../components/widget/search_collection_widget.dart';
import '../../components/widget/search_selection_widget.dart';
import '../../components/widget/search_user_widget.dart';
import '../../data/provider/search_provider.dart';

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
    bool isKeyword,
    int categoryIndex,
    String? searchText,
  ) async {
    final _searchProvider = context.read<SearchProvider>();

    if (searchText == null || searchText.isEmpty) return;

    switch (categoryIndex) {
      case 0:
        isKeyword
            ? await _searchProvider.getKeywordCollectionData(searchText)
            : await _searchProvider.getTagCollectionData(searchText);
        break;

      case 1:
        await _searchProvider.getSearchSelectionData(searchText);
        break;

      case 2:
        await _searchProvider.getSearchUsers(searchText);
        break;

      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Selector<SearchProvider, ({int item1, bool item2, String? item3})>(
        selector: (context, searchProvider) => (
              item1: searchProvider.selectedCategoryIndex,
              item2: searchProvider.isKeyword,
              item3: searchProvider.searchText,
            ),
        builder: (context, data, child) {
          int _categoryIndex = data.item1;
          bool _isKeyword = data.item2;
          String? _searchText = data.item3;

          return FutureBuilder(
              future: _doSearch(_isKeyword, _categoryIndex, _searchText),
              builder: (context, snapshot) {
                return Scaffold(
                  body: NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
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
                          flexibleSpace: FlexibleSpaceBar(
                            expandedTitleScale: 1,
                            centerTitle: false,
                            titlePadding: EdgeInsets.zero,
                            title: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0.h, horizontal: 16.0.w),
                              child: Container(
                                  height: 44.0.h,
                                  child: SearchCategoryWidget()),
                            ),
                            background: Padding(
                              padding: EdgeInsets.only(
                                left: 16.0.w,
                                right: 16.0.w,
                                top: ViewPaddingTopSize(context) + 14.0.h,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: 44.0.h,
                                    child: CustomSearchBar(
                                      autoFocus: false,
                                      enabled: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ];
                    },
                    body: snapshot.connectionState == ConnectionState.waiting
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : _searchText == null
                            ? Center(
                                child: Text(
                                  '검색어를 입력해보세요!',
                                  style: TextStyle(
                                    color: Color(0xFF868e96),
                                    fontSize: 14.sp,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                            : _categoryIndex == 0
                                ? SearchCollectionWidget(isKeyword: _isKeyword)
                                : _categoryIndex == 1
                                    ? SearchSelectionWidget()
                                    : _categoryIndex == 2
                                        ? SearchUserWidget()
                                        : const Center(
                                            child: Text('해당 카테고리가 없습니다.'),
                                          ),
                  ),
                );
              });
        });
  }
}
