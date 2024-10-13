import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/model/item_model.dart';
import '../../data/model/selection_model.dart';
import '../../data/provider/selection_provider.dart';

class Item extends StatelessWidget {
  final int index;
  const Item({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectionProvider>(builder: (context, provider, child) {
      final SelectionModel _selection = provider.selectionDetail!;
      List<ItemData> itemData = _selection.items!;

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFe9ecef),
              spreadRadius: 0,
              blurRadius: 10,
              offset: Offset(0, 0),
            )
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 20.0.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                itemData[index].itemTitle,
                style: TextStyle(
                  color: Color(0xFF343a40),
                  fontSize: 14.sp,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  height: 1.43,
                ),
              ),
              SizedBox(
                height: 16.0.h,
              ),
            ],
          ),
        ),
      );
    });
  }
}
