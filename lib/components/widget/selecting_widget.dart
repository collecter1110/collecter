import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/model/selecting_model.dart';
import '../../data/provider/selecting_provider.dart';
import '../card/selection.dart';
import '../ui_kit/status_tag.dart';

class SelectingWidget extends StatelessWidget {
  final bool isSelected;

  const SelectingWidget({
    super.key,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectingProvider>(builder: (context, provider, child) {
      List<String> _createdDates = isSelected
          ? provider.selectedCreatedDates
          : provider.selectingCreatedDates;

      if (provider.state == ConnectionState.waiting) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (provider.state == ConnectionState.done) {
        return _createdDates.isNotEmpty
            ? Container(
                color: Color(0xFFf8f9fa),
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 10.0.h),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: _createdDates.length,
                  itemBuilder: (context, index) {
                    List<SelectingData> selectDatas = isSelected
                        ? provider.selectedMap[_createdDates[index]] ?? []
                        : provider.selectingMap[_createdDates[index]] ?? [];

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
                                _createdDates[index],
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
                              top: 16.0.h,
                              bottom: 42.0.h,
                              left: 16.0.w,
                              right: 16.0.w),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 26.0.h,
                            crossAxisSpacing: 12.0.w,
                            childAspectRatio: 0.59,
                          ),
                          itemCount: selectDatas.length,
                          itemBuilder: (context, index) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                StatusTag(
                                  userName: selectDatas[index].userName,
                                  times: selectDatas[index].createdTime,
                                ),
                                Selection(
                                  routeName: '/user',
                                  title: selectDatas[index].selectionName,
                                  thumbFilePath:
                                      selectDatas[index].imageFilePath,
                                  keywords: selectDatas[index].keywords,
                                  ownerName: selectDatas[index].ownerName,
                                  ownerId: selectDatas[index].ownerId,
                                  properties: selectDatas[index].properties,
                                  isRanking: false,
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              )
            : Center(
                child: Text(
                  isSelected ? '셀렉팅 된 내역이 없습니다.' : '셀렉팅 한 내역이 없습니다.',
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
