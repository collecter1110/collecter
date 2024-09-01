import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Label {
  static Widget getLabel(int index) {
    switch (index) {
      case 0:
        return _buildLabel(
          text: 'New',
          backgroundColor: Color(0xFFfaedcd),
          textColor: Color(0xFF83c5be),
        );
      case 1:
        return _buildLabel(
          text: 'Hot',
          backgroundColor: Color(0xffffe1dd),
          textColor: Color(0xFFdc595f),
        );
      case 2:
        return _buildLabel(
          text: 'Trendy',
          backgroundColor: Color(0xFF234E70),
          textColor: Color(0xFFFBF8BE),
        );
      case 3:
        return _buildLabel(
          text: 'Rising',
          backgroundColor: Color(0xFF243665),
          textColor: Color(0xFF8BD8BD),
        );
      case 4:
        return _buildLabel(
          text: 'Best',
          backgroundColor: Color(0xFFb0c4b1),
          textColor: Color(0xFF4a5759),
        );
      default:
        return _buildLabel(
          text: 'null',
          backgroundColor: Color(0xFFced4da),
          textColor: Colors.white,
        );
    }
  }

  static Widget _buildLabel({
    required String text,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 0.5,
            blurRadius: 3,
            offset: Offset(2, 2),
          )
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 8.0.w,
        vertical: 3.0.h,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'PretendardRegular',
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: textColor,
          height: 1.5,
        ),
      ),
    );
  }
}
