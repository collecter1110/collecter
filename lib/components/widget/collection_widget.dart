import 'package:collect_er/components/card/collection.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/model/collection_model.dart';
import '../../data/provider/collection_provider.dart';

class CollectionWidget extends StatelessWidget {
  final bool? isLiked;
  const CollectionWidget({
    super.key,
    this.isLiked,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CollectionProvider>(builder: (context, provider, child) {
      final List<CollectionModel>? _collections;
      if (isLiked == null) {
        _collections = provider.searchUsersCollections;
      } else {
        _collections =
            isLiked! ? provider.likeCollections : provider.myCollections;
      }
      if (provider.state == ConnectionState.waiting) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (provider.state == ConnectionState.done) {
        return _collections!.isNotEmpty
            ? GridView.builder(
                padding:
                    EdgeInsets.symmetric(vertical: 22.0.h, horizontal: 16.0.w),
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
                    routName: isLiked == null ? '/search' : '/bookmark',
                    collectionDetail: _collection,
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
