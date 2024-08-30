import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../card/selection.dart';

class SelectWidget extends StatelessWidget {
  final bool isSelecting;
  const SelectWidget({super.key, required this.isSelecting});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFf8f9fa),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 20.0.h),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: 7,
        itemBuilder: (context, index) {
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
                      '2024-08-06',
                      style: TextStyle(
                        color: Color(0xFF868E96),
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
                        thickness: 0.5,
                        color: Color(0xFF868E96),
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
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: ShapeDecoration(
                          color: Color(0xFF212529),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0.w, vertical: 4.0.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '04:48:53',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 10.0.sp,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              isSelecting
                                  ? SizedBox.shrink()
                                  : Text(
                                      '부드러운 아보카도',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10.0.sp,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                      Selection(
                        index: index,
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
  }
}
