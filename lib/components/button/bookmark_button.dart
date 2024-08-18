import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookmarkButton extends StatelessWidget {
  final int listId;
  final bool isBookMarked;
  final bool inListDetail;

  const BookmarkButton({
    required this.listId,
    required this.isBookMarked,
    required this.inListDetail,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32.0.h,
      width: 32.0.w,
      child: InkWell(
        onTap: () async {},
        // child: isBookMarked
        //     ? (inListDetail
        //         ? SvgPicture.asset(
        //             'assets/icons/button_bookmark_fill_black.svg')
        //         : SvgPicture.asset(
        //             'assets/icons/button_bookmark_fill_white.svg'))
        //     : (inListDetail
        //         ? SvgPicture.asset(
        //             'assets/icons/button_bookmark_empty_black.svg')
        //         : SvgPicture.asset(
        //             'assets/icons/button_bookmark_empty_white.svg')),
      ),
    );
  }
}
