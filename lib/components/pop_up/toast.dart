import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Toast {
  static void error() {
    Fluttertoast.showToast(
      msg: "죄송합니다.\n현재 일시적인 오류가 발생했습니다.\n잠시 후 다시 시도해 주세요.",
      //  toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.black.withOpacity(0.7),
      textColor: Colors.white,
      fontSize: 18.0,
    );
  }

  static void missingFieldValue() {
    Fluttertoast.showToast(
      msg: "컬렉션 이름을\n입력해주세요",
      //  toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.black.withOpacity(0.7),
      textColor: Colors.white,
      fontSize: 18.0,
    );
  }
}
