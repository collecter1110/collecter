import 'package:collect_er/data/model/selecting_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/model/selection_model.dart';
import '../../data/provider/selection_provider.dart';
import '../card/selection.dart';

class SearchSelectionWidget extends StatelessWidget {
  final String routeName;

  const SearchSelectionWidget({
    super.key,
    required this.routeName,
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
        return _selections != null
            ? Container(
                color: Color(0xFFf8f9fa),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                  child: GridView.builder(
                    padding: EdgeInsets.symmetric(vertical: 22.0.h),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 24.0.h,
                      crossAxisSpacing: 12.0.w,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: _selections.length,
                    itemBuilder: (context, index) {
                      final SelectionModel _selection = _selections[index];
                      return Selection(
                        routeName: routeName,
                        properties: PropertiesData.fromJson(
                          {
                            "collection_id": _selection.collectionId,
                            "selection_id": _selection.selectionId,
                          },
                        ),
                        title: _selection.selectionName,
                        imageFilePath: _selection.imageFilePath,
                        ownerName: _selection.ownerName,
                        keywords: _selection.keywords,
                      );
                    },
                  ),
                ),
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
