import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'item.dart';

class OrderItem extends StatelessWidget {
  final int index;
  const OrderItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 16.0.w),
          child: Text(
            '${index + 1}',
            style: TextStyle(
              color: Color(0xFF343a40),
              fontSize: 18.sp,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(child: Item(index: index)),
      ],
    );
  }
}
