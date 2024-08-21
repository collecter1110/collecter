import 'package:collect_er/components/card/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../card/order_item.dart';

class SelectionItemWidget extends StatelessWidget {
  final bool isOrder;
  const SelectionItemWidget({
    super.key,
    required this.isOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFf8f9fa),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 12.0.h),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  isOrder ? 'ORDER' : 'LIST',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16.sp,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 20.0.h),
            shrinkWrap: true,
            primary: false,
            scrollDirection: Axis.vertical,
            itemCount: 3,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                child: isOrder ? OrderItem(index: index) : Item(index: index),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 12.0.h,
              );
            },
          ),
        ],
      ),
    );
  }
}
