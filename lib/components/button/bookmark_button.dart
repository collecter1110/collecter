import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookmarkButton extends StatelessWidget {
  final bool isBookMarked;
  final int likedNum;

  const BookmarkButton({
    required this.isBookMarked,
    required this.likedNum,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20.0.h,
      width: 20.0.w,
      child: InkWell(
        onTap: () async {},
        child: isBookMarked
            ? Image.asset(
                'assets/icons/icon_bookmark_fill.png',
                fit: BoxFit.contain,
              )
            : Image.asset(
                'assets/icons/icon_bookmark_light.png',
                fit: BoxFit.contain,
              ),
      ),
    );
  }
}
