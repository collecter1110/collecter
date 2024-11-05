import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCheckBox extends StatelessWidget {
  final bool checkState;
  final ValueChanged<bool?> onChanged;
  final String text;
  final Function? onTap;

  CustomCheckBox({
    required this.checkState,
    required this.onChanged,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0.w),
      child: Container(
        height: 24.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Transform.scale(
              scale: 2.5,
              child: FittedBox(
                fit: BoxFit.fill,
                child: Checkbox(
                  value: checkState,
                  onChanged: onChanged,
                  activeColor: Theme.of(context).primaryColor,
                  checkColor: Colors.white,
                  hoverColor: Colors.black,
                  side: BorderSide(width: 1.sp, color: Color(0xffCED4DA)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.0.w),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: onTap == null
                        ? Text(
                            text,
                            style: TextStyle(
                              fontFamily: 'PretendardRegular',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF343a40),
                              height: 1.0,
                            ),
                          )
                        : Text(
                            text,
                            style: TextStyle(
                              fontFamily: 'PretendardRegular',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF343a40),
                              height: 1.4,
                            ),
                          ),
                  ),
                  onTap != null
                      ? InkWell(
                          onTap: () {
                            onTap != null ? onTap!() : null;
                          },
                          child: Image.asset(
                            'assets/icons/icon_arrow_right.png',
                            height: 16.0.h,
                            color: Color(
                              0xFFadb5bd,
                            ),
                          ),
                        )
                      : SizedBox.shrink()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
