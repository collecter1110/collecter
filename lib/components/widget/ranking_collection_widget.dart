import 'package:collect_er/components/card/collection.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/model/collection_model.dart';
import '../../data/provider/ranking_provider.dart';

class RankingCollectionWidget extends StatelessWidget {
  const RankingCollectionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<RankingProvider>(builder: (context, provider, child) {
      final List<CollectionModel>? _collections;

      _collections = provider.rankingCollections;
      print(_collections);
      if (provider.state == ConnectionState.waiting) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (provider.state == ConnectionState.done) {
        return (_collections != null && _collections.isNotEmpty)
            ? GridView.builder(
                padding: EdgeInsets.symmetric(
                  vertical: 22.0.h,
                ),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 24.0.h,
                  crossAxisSpacing: 12.0.w,
                  childAspectRatio: 0.65,
                ),
                itemCount: _collections.length,
                itemBuilder: (context, index) {
                  final CollectionModel _collection = _collections![index];
                  return Collection(
                    routName: '/',
                    collectionDetail: _collection,
                  );
                },
              )
            : Center(
                child: Text(
                  '랭킹 컬렉션이 없습니다.\n좋아요를 많이 받아 랭킹 컬렉션에 도전해보세요!',
                  style: TextStyle(
                    color: Color(0xFF868e96),
                    fontSize: 14.sp,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
      } else {
        return const Center(
          child: Text('Error occurred.'),
        );
      }
    });
  }
}
