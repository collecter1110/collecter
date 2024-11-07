import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/model/selecting_model.dart';
import '../../data/services/api_service.dart';
import '../button/complete_button.dart';
import '../button/set_report_button.dart';
import '../constants/screen_size.dart';

class ReportDialog extends StatelessWidget {
  final Future<void> Function()? voidCallback;
  final int? collectionId;
  final PropertiesData? selectionProperties;
  final int? userId;
  final int reportType;
  ReportDialog({
    super.key,
    this.collectionId,
    this.selectionProperties,
    this.userId,
    this.voidCallback,
    required this.reportType,
  });

  @override
  Widget build(BuildContext context) {
    int? selectedReportIndex;
    List<String> _reportContext = [
      '허위/거짓 정보',
      '욕설 및 비방',
      '부적절한 음란/선정적 콘텐츠',
      '다른 유저의 게시글 도용'
    ];

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0.r),
              topRight: Radius.circular(16.0.r),
            ),
            color: Colors.white,
          ),
          height: screenHeight(context) * 1 / 2,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 24.0.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '신고하기',
                      style: TextStyle(
                        fontFamily: 'PretendardRegular',
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        height: 1.2,
                      ),
                    ),
                    InkWell(
                      child: SizedBox(
                        height: 16.0.h,
                        child: Image.asset(
                          'assets/icons/button_delete.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0.h),
                  child: Text(
                    '신고 3건 이상 접수 시, 24시간 내 심사 후 게시물이 삭제됩니다.\n(사용자 신고가 누적되면 계정이 1주일간 정지됩니다.)',
                    style: TextStyle(
                      fontFamily: 'PretendardRegular',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      height: 1.5,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0.h),
                    child: ListView.separated(
                      primary: false,
                      scrollDirection: Axis.vertical,
                      itemCount: _reportContext.length,
                      itemBuilder: (context, index) {
                        return SetReportButton(
                          title: _reportContext[index],
                          index: index,
                          selectedIndex: selectedReportIndex,
                          onTap: (value) {
                            setState(() {
                              selectedReportIndex = value;
                            });
                          },
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: 8.0.h,
                        );
                      },
                    ),
                  ),
                ),
                CompleteButton(
                  firstFieldState: true,
                  secondFieldState: selectedReportIndex != null,
                  onTap: () async {
                    Map<String, int>? reportedPostId;
                    if (reportType == 0) {
                      reportedPostId = {
                        "user_id": userId!,
                      };
                    } else if (reportType == 1) {
                      reportedPostId = {
                        "collection_id": collectionId!,
                      };
                    } else {
                      reportedPostId = selectionProperties!.toMap();
                    }
                    print(reportedPostId);
                    print(_reportContext[selectedReportIndex!]);
                    ApiService.report(reportType, reportedPostId,
                        _reportContext[selectedReportIndex!]);
                    Navigator.pop(context);
                    await voidCallback?.call();
                  },
                  text: '신고하기',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
