import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/model/selecting_model.dart';

import '../../data/provider/select_provider.dart';
import '../card/selection.dart';

import '../pop_up/error_messege_toast.dart';
import '../ui_kit/select_status_tag.dart';

class SelectWidget extends StatelessWidget {
  const SelectWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectProvider>(builder: (context, provider, child) {
      List<String> _createdDates = provider.createdDates;
      if (provider.state == ConnectionState.waiting) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (provider.state == ConnectionState.done) {
        return Container(
          color: Color(0xFFf8f9fa),
          child: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 10.0.h),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: _createdDates.length,
            itemBuilder: (context, index) {
              List<SelectingData> selectDatas = provider.getSelectDatas(index);

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
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 26.0.h,
                      crossAxisSpacing: 12.0.w,
                      childAspectRatio: 0.62,
                    ),
                    itemCount: selectDatas.length,
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SelectStatusTag(
                            userName: selectDatas[index].userName,
                            times: selectDatas[index].createdTime,
                          ),
                          Selection(
                            title: selectDatas[index].selectionName,
                            imageFilePath: selectDatas[index].imageFilePath,
                            keywords: selectDatas[index].keywords,
                            ownerName: selectDatas[index].ownerName,
                            properties: selectDatas[index].properties,
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
      } else {
        ErrorMessegeToast.error(); // 에러 토스트 표시
        print('get error');
        return const Center(
          child: Text('Error occurred.'),
        );
      }
    });
  }
}
