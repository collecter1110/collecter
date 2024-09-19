import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/model/collection_model.dart';
import '../../data/provider/collection_provider.dart';
import '../card/search_collection.dart';

class SearchCollectionWidget extends StatelessWidget {
  const SearchCollectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CollectionProvider>(builder: (context, provider, child) {
      final List<CollectionModel>? _collections = provider.searchCollections;
      if (provider.state == ConnectionState.waiting) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (provider.state == ConnectionState.done) {
        return _collections != null
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
            : const Center(
                child: Text('일치하는 데이터가 없습니다.'),
              );
      } else {
        return const Center(
          child: Text('Error occurred.'),
        );
      }
    });
  }
}
