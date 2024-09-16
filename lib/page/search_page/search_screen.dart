import 'package:collect_er/components/widget/search_collection_widget.dart';
import 'package:collect_er/data/provider/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../components/button/custom_ search_bar.dart';
import '../../components/constants/screen_size.dart';
import '../../components/widget/search_category_widget.dart';
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

  Future<void> _onSearch(bool isKeyword) async {
    final _collectionProvider = context.read<CollectionProvider>();

    _collectionProvider.getSearchCollectionData(_searchText!, isKeyword);
  }

  @override
  void dispose() {
    super.dispose();
  }

  String? _searchText;
  bool _isKeyword = true;

  @override
  Widget build(BuildContext context) {
    final _searchProvider = context.watch<SearchProvider>();
    _isKeyword = _searchProvider.selectedSubCategoryIndex == 0;

    if (_searchText != null && _searchText != '') {
      _onSearch(_isKeyword);
    }
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
                    title: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0.h, horizontal: 16.0.w),
                      child: SearchCategoryWidget(),
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
                          setState(() {
                            _searchText = value;
                            _onSearch(_isKeyword);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ];
        },
        body: _searchText == null ? Container() : SearchCollectionWidget(),
      ),
    );
  }
}
