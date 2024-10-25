import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../button/complete_button.dart';
import '../widget/collection_cover_image_widget.dart';

class CollectionCoverDialog extends StatefulWidget {
  final int collectionId;
  final Future<void> Function() voidCallback;

  const CollectionCoverDialog({
    super.key,
    required this.collectionId,
    required this.voidCallback,
  });

  @override
  State<CollectionCoverDialog> createState() => _CollectionCoverDialogState();
}

class _CollectionCoverDialogState extends State<CollectionCoverDialog> {
  @override
  Widget build(BuildContext context) {
    bool isSelected = false;
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
          color: Colors.white,
        ),
        height: 400.0.h,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 24.0.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '커버 이미지를 선택해주세요.',
                    style: TextStyle(
                      fontFamily: 'PretendardRegular',
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      height: 1.2,
                    ),
                  ),
                  InkWell(
                    child: SizedBox(
                      height: 16.0.h,
                      child: Image.asset(
                        'assets/icons/button_delete.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              Expanded(
                child: CollectionCoverImageWidget(
                  collectionId: widget.collectionId,
                  isSelected: (value) {
                    setState(() {
                      isSelected = value;
                    });
                  },
                ),
              ),
              CompleteButton(
                firstFieldState: true,
                secondFieldState: isSelected,
                onTap: () async {
                  Navigator.pop(context);
                  await widget.voidCallback.call();
                },
                text: '선택',
              ),
            ],
          ),
        ),
      );
    });
  }
}
