import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;
  final VoidCallback? actionButtonOnTap;
  final String? actionButton;

  const CustomAppbar({
    Key? key,
    required this.titleText,
    this.actionButtonOnTap,
    this.actionButton,
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
            height: 20.h,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset(
                'assets/icons/icon_back.png',
              ),
            ),
          ),
          Text(
            titleText,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 18.0.sp,
            ),
          ),
          SizedBox(
            height: 20.0.h,
            child: actionButton != null
                ? InkWell(
                    onTap: actionButtonOnTap,
                    child: Image.asset(
                      'assets/icons/${actionButton}.png',
                    ),
                  )
                : SizedBox.shrink(),
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
