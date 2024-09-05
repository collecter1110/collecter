import 'package:collect_er/data/model/selecting_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../card/selection.dart';

class SelectionWidget extends StatelessWidget {
  const SelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(vertical: 22.0.h),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 24.0.h,
        crossAxisSpacing: 12.0.w,
        childAspectRatio: 0.7,
      ),
      itemCount: 7,
      itemBuilder: (context, index) {
        return Selection(
          properties: PropertiesData.fromJson(
            {"collection_id": 3, "selection_id": 2, "user_id": 31},
          ),
          title: 'selectingDatas[index].selectionName',
          imageFilePath: 'selectingDatas[index].imageFilePath?',
          ownerName: 'selectingDatas[index].ownerName',
        );
      },
    );
  }
}
