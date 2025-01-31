import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/model/collection_model.dart';
import '../../data/provider/collection_provider.dart';
import '../card/collection.dart';

class CollectionWidget extends StatelessWidget {
  final int? categoryId;
  final bool? isLiked;
  final String routeName;
  const CollectionWidget({
    super.key,
    this.categoryId,
    this.isLiked,
    required this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CollectionProvider>(builder: (context, provider, child) {
      List<CollectionModel>? _collections;
      if (isLiked == null) {
        _collections = provider.searchUsersCollections;
      } else {
        _collections =
            isLiked! ? provider.likeCollections : provider.myCollections;
        if (categoryId != null) {
          _collections = _collections?.where((collection) {
            return collection.categoryId == categoryId;
          }).toList();
        }
      }
      if (provider.state == ConnectionState.waiting || _collections == null) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (provider.state == ConnectionState.done) {
        return _collections.isNotEmpty
            ? GridView.builder(
                padding:
                    EdgeInsets.symmetric(vertical: 22.0.h, horizontal: 16.0.w),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 24.0.h,
                  crossAxisSpacing: 12.0.w,
                  childAspectRatio: 0.68,
                ),
                itemCount: _collections.length,
                itemBuilder: (context, index) {
                  final CollectionModel _collection = _collections![index];
                  return Collection(
                    routName: routeName,
                    collectionDetail: _collection,
                    isRanking: isLiked == true,
                  );
                },
              )
            : Center(
                child: Text(
                  isLiked == true
                      ? '좋아요를 눌러 마음에 드는 컬렉션을 저장해보세요!'
                      : isLiked == false
                          ? '새로운 컬렉션을 추가해보세요!'
                          : '컬렉션이 없습니다.',
                  style: TextStyle(
                    color: Color(0xFF868e96),
                    fontSize: 14.sp,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                  ),
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
