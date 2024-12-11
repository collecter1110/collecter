import 'package:collecter/data/model/selection_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/model/selecting_model.dart';
import '../../data/provider/ranking_provider.dart';
import '../card/selection.dart';
import '../ui_kit/category_banner.dart';

class CategorySelectionWidget extends StatelessWidget {
  final int categoryId;

  const CategorySelectionWidget({
    super.key,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFf8f9fa),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 12.0.h),
            child: CategoryBanner(
              showDescription: false,
              categoryId: categoryId,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0.h),
            child:
                Consumer<RankingProvider>(builder: (context, provider, child) {
              final List<SelectionModel>? _selections;
              if (categoryId == 4) {
                _selections = provider.movieSelections;
              } else if (categoryId == 1) {
                _selections = provider.musicSelections;
              } else if (categoryId == 3) {
                _selections = provider.bookSelections;
              } else {
                _selections = null;
              }

              if (_selections == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return (_selections.isNotEmpty)
                  ? SizedBox(
                      height: 240.0.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(
                          horizontal: 18.0.w,
                        ),
                        shrinkWrap: true,
                        itemCount: _selections.length,
                        itemBuilder: (context, index) {
                          final SelectionModel _selection = _selections![index];
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0.h),
                            child: AspectRatio(
                              aspectRatio: 0.63,
                              child: Selection(
                                routeName: '/',
                                properties: PropertiesData.fromJson(
                                  {
                                    "collection_id": _selection.collectionId,
                                    "selection_id": _selection.selectionId,
                                  },
                                ),
                                title: _selection.title,
                                thumbFilePath: _selection.thumbFilePath,
                                ownerName: _selection.ownerName,
                                ownerId: _selection.ownerId,
                                keywords: _selection.keywords,
                                isRanking: true,
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            width: 16.0.w,
                          );
                        },
                      ),
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
            }),
          ),
        ],
      ),
    );
  }
}
