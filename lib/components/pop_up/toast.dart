import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class Toast {
  static Future<bool?> warningDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("오류 발생"),
          content: Text("컬렉션과 관련된 셀렉션도 함께 삭제됩니다.\n삭제하시겠습니까?"),
          actions: <Widget>[
            TextButton(
              child: Text("확인"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            TextButton(
              child: Text("취소"),
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
                child: Text("기본 이미지로 변경", style: contentTextStyle),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              Divider(height: 0.5.h, color: Color(0xFFe9ecef)),
              TextButton(
                child: Text(
                  "앨범에서 선택",
                  style: contentTextStyle,
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
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

  static void missingField(String message) {
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
        msg: "앨범 접근 권한이 영구적으로 거부되었습니다. 설정에서 권한을 변경해주세요.",
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
        Toast.missingField(condition.key);
        return false;
      }
    }
    return true;
  }
}
