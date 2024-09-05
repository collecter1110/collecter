import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/model/item_model.dart';
import '../../data/model/selection_detail_model.dart';
import '../../data/provider/selection_detail_provider.dart';
import '../button/link_button.dart';

class Item extends StatelessWidget {
  final int index;
  const Item({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectionDetailProvider>(
        builder: (context, provider, child) {
      final SelectionDetailModel _selection = provider.selectionDetailModel!;
      List<ItemData> itemData = _selection.items!;

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0.5,
              blurRadius: 3,
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
              itemData[index].itemLink != null
                  ? LinkButton(
                      linkUrl: itemData[index].itemLink!,
                    )
                  : SizedBox.shrink()
            ],
          ),
        ),
      );
    });
  }
}
