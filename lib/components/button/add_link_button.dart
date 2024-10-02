import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddLinkButton extends StatelessWidget {
  final VoidCallback onTap;
  const AddLinkButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onTap();
      },
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        padding: EdgeInsets.symmetric(vertical: 3.0.h, horizontal: 6.0.w),
        backgroundColor: Color(0xFFced4da),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: Size.zero,
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/icons/icon_plus_fill.png',
            height: 10.0.h,
            color: Colors.white,
          ),
          SizedBox(
            width: 4.0.w,
          ),
          Text(
            '링크',
            style: TextStyle(
                fontFamily: 'PretendardRegular',
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                height: 1.43),
          ),
        ],
      ),
    );
  }
}
