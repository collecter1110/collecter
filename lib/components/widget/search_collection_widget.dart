import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/model/collection_model.dart';
import '../../data/provider/collection_provider.dart';
import '../card/search_collection.dart';

class SearchCollectionWidget extends StatelessWidget {
  final bool isKeyword;
  const SearchCollectionWidget({super.key, required this.isKeyword});

  @override
  Widget build(BuildContext context) {
    return Consumer<CollectionProvider>(builder: (context, provider, child) {
      final List<CollectionModel>? _collections = isKeyword
          ? provider.searchKeywordCollections
          : provider.searchTagCollections;

      return _collections!.isNotEmpty
          ? GridView.builder(
              padding:
                  EdgeInsets.symmetric(vertical: 22.0.h, horizontal: 16.0.w),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisSpacing: 24.0.h,
                crossAxisSpacing: 12.0.w,
                childAspectRatio: 3,
              ),
              itemCount: _collections.length,
              itemBuilder: (context, index) {
                final CollectionModel _collection = _collections[index];

                return SearchCollection(
                  collectionDetail: _collection,
                );
              },
            )
          : Center(
              child: Text(
                '일치하는 데이터가 없습니다.',
                style: TextStyle(
                  color: Color(0xFF868e96),
                  fontSize: 14.sp,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
    });
  }
}
