import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/provider/collection_provider.dart';
import '../../page/collection/collection_detail_screen.dart';

class GoCollectionButton extends StatelessWidget {
  final int collectionId;
  final String collectionName;
  const GoCollectionButton({
    super.key,
    required this.collectionId,
    required this.collectionName,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        context.read<CollectionProvider>().saveCollectionId = collectionId;
        await context.read<CollectionProvider>().getCollectionDetailData();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CollectionDetailScreen(),
            settings: RouteSettings(name: '/search'),
          ),
        );
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 3.0.h, horizontal: 0.0.w),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: Size.zero,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            collectionName,
            style: TextStyle(
              color: Color(0xFF868e96),
              fontSize: 10.0.sp,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w700,
              height: 1.4,
            ),
          ),
          SizedBox(
            width: 6.0.w,
          ),
          Image.asset(
            'assets/icons/icon_arrow_circle.png',
            height: 14.0.h,
            color: Color(0xFF1b4d3e),
          ),
        ],
      ),
    );
  }
}
