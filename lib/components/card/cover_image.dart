import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widget/image_widget.dart';

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
        aspectRatio: 0.9,
        child: Stack(
          children: [
            ImageWidget(
              storageFolderName: '$ownerId/selections',
              imageFilePath: thumbFilePath,
              borderRadius: 8.r,
            ),
            isSelected
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: isSelected
                          ? Colors.black.withOpacity(0.5)
                          : Colors.transparent,
                    ),
                  )
                : SizedBox.shrink(),
            isSelected
                ? Positioned(
                    right: 6.0.w,
                    top: 6.0.h,
                    child: Image.asset(
                      'assets/icons/icon_check.png',
                      height: 18.0.h,
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
