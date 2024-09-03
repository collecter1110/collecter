import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/model/selecting_model.dart';

import '../../data/provider/select_provider.dart';
import '../card/selection.dart';
import '../ui_kit/select_status_tag.dart';

class SelectWidget extends StatelessWidget {
  final bool isSelecting;
  const SelectWidget({super.key, required this.isSelecting});

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectProvider>(builder: (context, provider, child) {
      List<String> keyList = provider.dateTimesMap.keys.toList();

      return Container(
        color: Color(0xFFf8f9fa),
        child: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 10.0.h),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: keyList.length,
          itemBuilder: (context, index) {
            List<SelectingData> selectingDatas =
                provider.dateTimesMap[keyList[index]] ?? [];

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        keyList[index],
                        style: TextStyle(
                          color: Color(0xFFadb5bd),
                          fontSize: 12.0.sp,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(
                        width: 10.0.w,
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 1.0.h,
                          color: Color(0xFFdee2e6),
                        ),
                      ),
                    ],
                  ),
                ),
                GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.only(
                      top: 16.0.h, bottom: 42.0.h, left: 16.0.w, right: 16.0.w),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 26.0.h,
                    crossAxisSpacing: 12.0.w,
                    childAspectRatio: 0.62,
                  ),
                  itemCount: selectingDatas.length,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SelectStatusTag(
                          isSelecting: isSelecting,
                          times: selectingDatas[index].createdTime,
                        ),
                        Selection(
                          title: selectingDatas[index].selectionName,
                          imageFilePath: selectingDatas[index].imageFilePath,
                          keywords: selectingDatas[index].keywords,
                          ownerName: selectingDatas[index].ownerName,
                        ),
                      ],
                    );
                  },
                ),
              ],
            );
          },
        ),
      );
    });
  }
}
