import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/provider/collection_provider.dart';
import '../../data/services/api_service.dart';

class LikedButton extends StatelessWidget {
  final int collectionId;
  final bool isLiked;
  final int likedNum;

  const LikedButton({
    required this.collectionId,
    required this.isLiked,
    required this.likedNum,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        isLiked
            ? await ApiService().actionUnlike(collectionId)
            : await ApiService().actionLike(collectionId);

        final collectionProvider = context.read<CollectionProvider>();
        await collectionProvider.fetchCollectionDetail();
        await collectionProvider.fetchLikeCollections();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.0.w),
        child: Column(
          children: [
            SizedBox(
              height: 20.0.h,
              width: 20.0.w,
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
        ),
      ),
    );
  }
}
