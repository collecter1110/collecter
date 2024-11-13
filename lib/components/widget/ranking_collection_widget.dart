import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../data/model/collection_model.dart';
import '../../data/provider/ranking_provider.dart';
import '../card/collection.dart';

class RankingCollectionWidget extends StatelessWidget {
  const RankingCollectionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<RankingProvider>(builder: (context, provider, child) {
      final List<CollectionModel>? _collections = provider.rankingCollections;
      if (_collections == null) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      return (_collections.isNotEmpty)
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
                '랭킹 컬렉션이 없습니다.\n좋아요를 많이 받아보세요!',
                style: TextStyle(
                  color: Color(0xFF868e96),
                  fontSize: 14.sp,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            );
    });
  }
}
