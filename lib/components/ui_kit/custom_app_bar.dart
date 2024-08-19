import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final bool popState;
  final String titleText;
  final bool titleState;
  final VoidCallback? actionButtonOnTap;
  final String? actionButton;

  const CustomAppbar({
    Key? key,
    required this.popState,
    required this.titleText,
    required this.titleState,
    required this.actionButtonOnTap,
    required this.actionButton,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(60.0.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 32.w,
            child: popState
                ? InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back), // 임시로 아이콘 사용
                  )
                : SizedBox.shrink(), // child가 null일 때 크기를 최소화
          ),
          titleState
              ? Text(
                  titleText,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 18.0.sp,
                  ),
                )
              : SizedBox.shrink(), // 제목이 없을 때 크기를 최소화
          SizedBox(
            width: 32.w,
            child: actionButton != null
                ? InkWell(
                    onTap: actionButtonOnTap,
                    child: Icon(Icons.menu), // 임시로 아이콘 사용
                  )
                : SizedBox.shrink(), // child가 null일 때 크기를 최소화
          ),
        ],
      ),
      titleSpacing: 16.0.w,
      shape: const Border(
        bottom: BorderSide(
          color: Color(0xffe9ecef),
          width: 1,
        ),
      ),
    );
  }
}
