import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class Toast {
  static Future<void> showNoticeDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text("알림"),
          content: Text(
              "죄송합니다.\n기본 메일 앱 사용이 불가능하여 앱에서 바로 메일을 전송할 수 없습니다.\n아래 명시된 이메일로 연락 주시면 친절하고 빠르게 답변해드리겠습니다.\n\n감사합니다:)\n\n\n contact.collecter@gmail.com"),
          actions: <Widget>[
            TextButton(
              child: Text(
                '확인',
                style: TextStyle(
                  fontFamily: 'PretendardRegular',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Future<bool?> showConfirmationDialog(
      BuildContext context, String contents) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text("알림"),
          content: Text(contents),
          actions: <Widget>[
            TextButton(
              child: Text(
                '확인',
                style: TextStyle(
                  fontFamily: 'PretendardRegular',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            TextButton(
              child: Text(
                '취소',
                style: TextStyle(
                  fontFamily: 'PretendardRegular',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    );
  }

  static Future<bool?> selectImageDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        TextStyle contentTextStyle = TextStyle(
          fontFamily: 'PretendardRegular',
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        );
        return AlertDialog(
          backgroundColor: Colors.white,
          contentPadding:
              EdgeInsets.symmetric(vertical: 0.0.h, horizontal: 0.0.h),
          actions: null,
          contentTextStyle: TextStyle(fontSize: 16.sp, color: Colors.black),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextButton(
                child: Text(
                  "이미지 선택",
                  style: contentTextStyle,
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              Divider(height: 0.5.h, color: Color(0xFFe9ecef)),
              TextButton(
                child: Text("기본 이미지로 변경", style: contentTextStyle),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  static void error() {
    Fluttertoast.showToast(
      msg: "죄송합니다.\n현재 일시적인 오류가 발생했습니다.\n잠시 후 다시 시도해 주세요.",
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.black.withOpacity(0.7),
      textColor: Colors.white,
      fontSize: 18.0,
    );
  }

  static void notify(String message) {
    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.black.withOpacity(0.7),
      textColor: Colors.white,
      fontSize: 18.0,
    );
  }

  static void completeToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.black.withOpacity(0.7),
      textColor: Colors.white,
      fontSize: 18.0,
    );
  }

  static Future<void> handlePhotoPermission(PermissionStatus status) async {
    if (status.isDenied) {
      Fluttertoast.showToast(
        msg: "앨범 접근 권한이 거부되었습니다.",
        backgroundColor: Colors.black.withOpacity(0.7),
        textColor: Colors.white,
        fontSize: 18.0,
        gravity: ToastGravity.CENTER,
      );
      await Future.delayed(Duration(seconds: 1));
      await openAppSettings();
    } else if (status.isPermanentlyDenied) {
      Fluttertoast.showToast(
        msg: "앨범 접근 권한이 일시적으로 거부되었습니다. 설정에서 권한을 변경해주세요.",
        backgroundColor: Colors.black.withOpacity(0.7),
        textColor: Colors.white,
        fontSize: 18.0,
        gravity: ToastGravity.CENTER,
      );
      await Future.delayed(Duration(seconds: 1));
      await openAppSettings();
    }
    print(status);
  }
}

class FieldValidator {
  final Map<String, bool> conditions;

  FieldValidator(this.conditions);

  bool validateFields() {
    for (var condition in conditions.entries) {
      if (!condition.value) {
        Toast.notify(condition.key);
        return false;
      }
    }
    return true;
  }
}
