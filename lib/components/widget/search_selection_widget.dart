import 'package:collect_er/data/model/selecting_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/model/selection_model.dart';
import '../../data/provider/selection_provider.dart';
import '../card/search_selection.dart';

class SearchSelectionWidget extends StatelessWidget {
  const SearchSelectionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectionProvider>(builder: (context, provider, child) {
      final List<SelectionModel>? _selections = provider.searchSelections;

      if (provider.state == ConnectionState.waiting) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (provider.state == ConnectionState.done) {
        return _selections!.isNotEmpty
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
                itemCount: _selections.length,
                itemBuilder: (context, index) {
                  final SelectionModel _selection = _selections[index];

                  return SearchSelection(
                    selectionDetail: _selection,
                    properties: PropertiesData.fromJson(
                      {
                        "collection_id": _selection.collectionId,
                        "selection_id": _selection.selectionId,
                      },
                    ),
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
