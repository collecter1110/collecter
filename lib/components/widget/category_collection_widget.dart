import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../data/model/collection_model.dart';
import '../../data/provider/ranking_provider.dart';
import '../card/collection.dart';
import '../ui_kit/category_banner.dart';

class CategoryCollectionWidget extends StatelessWidget {
  final int categoryId;

  const CategoryCollectionWidget({
    super.key,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 18.0.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CategoryBanner(
            showDescription: false,
            categoryId: categoryId,
          ),
          Padding(
            padding: EdgeInsets.only(top: 24.0.h),
            child:
                Consumer<RankingProvider>(builder: (context, provider, child) {
              final List<CollectionModel>? _collections;
              if (categoryId == 4) {
                _collections = provider.movieCollections;
              } else if (categoryId == 1) {
                _collections = provider.musicCollections;
              } else if (categoryId == 3) {
                _collections = provider.bookCollections;
              } else if (categoryId == 5) {
                _collections = provider.cookCollections;
              } else if (categoryId == 2) {
                _collections = provider.tripCollections;
              } else if (categoryId == 6) {
                _collections = provider.placeCollections;
              } else if (categoryId == 7) {
                _collections = provider.tastingNoteCollections;
              } else if (categoryId == 8) {
                _collections = provider.knittingCollections;
              } else {
                _collections = null;
              }

              if (_collections == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return (_collections.isNotEmpty)
                  ? SizedBox(
                      height: 240.0.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(
                          horizontal: 18.0.w,
                        ),
                        shrinkWrap: true,
                        itemCount: _collections.length,
                        itemBuilder: (context, index) {
                          final CollectionModel _collection =
                              _collections![index];
                          return AspectRatio(
                            aspectRatio: 0.63,
                            child: Collection(
                              routName: '/',
                              collectionDetail: _collection,
                              isRanking: true,
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            width: 12.0.w,
                          );
                        },
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.0.h),
                      child: Center(
                        child: Text(
                          '랭킹 컬렉션이 없습니다.\n좋아요를 많이 받아보세요!',
                          style: TextStyle(
                            color: Color(0xFF868e96),
                            fontSize: 12.sp,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
            }),
          ),
        ],
      ),
    );
  }
}
