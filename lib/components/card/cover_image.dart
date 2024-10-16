import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/services/data_management.dart';

class CoverImage extends StatelessWidget {
  final int coverIndex;
  int? selectedCoverIndex;
  final String thumbFilePath;
  final int ownerId;
  final ValueSetter<int> onTap;

  CoverImage({
    super.key,
    required this.coverIndex,
    this.selectedCoverIndex,
    required this.thumbFilePath,
    required this.ownerId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = coverIndex == selectedCoverIndex;
    return GestureDetector(
      onTap: () {
        onTap(coverIndex);
      },
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Color(0xFFced4da),
                  width: isSelected ? 3.0.w : 0.5.w,
                ),
                borderRadius: BorderRadius.circular(8.r),
                image: DecorationImage(
                  image: NetworkImage(
                    DataManagement.getFullImageUrl(
                        '$ownerId/selections', thumbFilePath),
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: isSelected
                      ? Colors.black.withOpacity(0.3)
                      : Colors.transparent,
                ),
              ),
            ),
            isSelected
                ? Positioned(
                    right: 8.0.w,
                    top: 8.0.h,
                    child: Image.asset(
                      'assets/icons/icon_check.png',
                      height: 24.0.h,
                      color: Theme.of(context).primaryColor,
                    ),
                  )
                : SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
