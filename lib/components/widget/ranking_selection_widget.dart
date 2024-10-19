import 'package:collect_er/data/model/selection_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/model/selecting_model.dart';
import '../../data/provider/ranking_provider.dart';
import '../card/selection.dart';

class RankingSelectionWidget extends StatelessWidget {
  const RankingSelectionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<RankingProvider>(builder: (context, provider, child) {
      final List<SelectionModel>? _selections;

      _selections = provider.rankingSelections;

      if (provider.state == ConnectionState.waiting) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (provider.state == ConnectionState.done) {
        return (_selections != null && _selections.isNotEmpty)
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
                itemCount: _selections.length,
                itemBuilder: (context, index) {
                  final SelectionModel _selection = _selections![index];
                  return Selection(
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
                  );
                },
              )
            : Center(
                child: Text(
                  '랭킹 셀렉션이 없습니다.\n셀렉팅을 많이 받아보세요!',
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
