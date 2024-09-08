import 'package:collect_er/data/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/provider/collection_provider.dart';

class likedButton extends StatelessWidget {
  final int collectionId;
  final bool isLiked;
  final int likedNum;

  const likedButton({
    required this.collectionId,
    required this.isLiked,
    required this.likedNum,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20.0.h,
          width: 20.0.w,
          child: InkWell(
            onTap: () async {
              isLiked
                  ? await ApiService().actionUnlike(collectionId)
                  : await ApiService().actionLike(collectionId);
              await context
                  .read<CollectionProvider>()
                  .getCollectionDetailData();
            },
            child: isLiked
                ? Image.asset(
                    'assets/icons/icon_heart_fill.png',
                    fit: BoxFit.contain,
                  )
                : Image.asset(
                    'assets/icons/icon_heart_light.png',
                    fit: BoxFit.contain,
                  ),
          ),
        ),
        Text(
          '$likedNum',
          style: TextStyle(
            color: Color(0xFF495057),
            fontSize: 10.sp,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
