import 'dart:async';

import 'package:collect_er/components/button/complete_button.dart';
import 'package:collect_er/data/services/api_service.dart';
import 'package:collect_er/page_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/button/authentication_button.dart';
import '../../components/text_field/custom_text_form_field.dart';

class EmailLoginScreen extends StatefulWidget {
  const EmailLoginScreen({Key? key}) : super(key: key);

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  bool _emailAddressFilled = false;
  bool _emailAddressValid = false;

  bool _emailAuthFilled = false;
  bool _emailAuthState = false;

  FocusNode _emailAddressFocus = FocusNode();
  FocusNode _emailAuthFocus = FocusNode();

  final _emailAddressFormKey = GlobalKey<FormState>();
  final _emailAuthFormKey = GlobalKey<FormState>();

  String emailAddress = '';
  String authNumber = '';

  late Timer _timer;
  int remainingTime = 180;
  bool _timerState = false;

  @override
  void initState() {
    super.initState();

    _emailAddressFocus.addListener(() {
      setState(() {
        _handleEmailAddressValid();
      });
    });
    _emailAuthFocus.addListener(() {
      setState(() {
        _handleEmailAuthValid();
      });
    });
  }

  String? _checkEmailAddressValid(String? value) {
    if (_emailAddressFocus.hasFocus) {
      _emailAddressValid = true;
      return null;
    }
    if (!_emailAddressValid && _emailAddressFilled) {
      return '해당 이메일로 가입된 내역이 없습니다.';
    }
  }

  String? _checkEmailAuthValid(String? value) {
    if (_emailAuthFocus.hasFocus) {
      _emailAuthState = true;
      return null;
    }
    if (!_emailAuthState && _emailAuthFilled) {
      return '인증번호가 올바르지 않습니다.';
    }
  }

  void startTimer() {
    _timerState ? _timer.cancel() : null;
    remainingTime = 180;
    _timerState = true;

    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        resetTimer();
      }
    });
  }

  void resetTimer() {
    setState(() {
      _timerState ? _timer.cancel() : null;
      _timerState = false;
    });
  }

  Future<void> _emailVerifiedRequest() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      FocusScope.of(context).unfocus();
      _emailAddressValid = !await ApiService.checkEmailDuplicate(emailAddress);
      print(_emailAddressValid);
      if (_emailAddressValid) {
        await ApiService.emailLogin(emailAddress);
        FocusScope.of(context).requestFocus(_emailAuthFocus);
        startTimer();
      } else {
        _handleEmailAddressValid();
      }
    } finally {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  void _handleEmailAddressValid() {
    final formKeyState = _emailAddressFormKey.currentState!;
    if (formKeyState.validate()) {
      formKeyState.save();
    }
  }

  void _handleEmailAuthValid() {
    final formKeyState = _emailAuthFormKey.currentState!;
    if (formKeyState.validate()) {
      formKeyState.save();
    }
  }

  @override
  void dispose() {
    _emailAddressFocus.dispose();
    _emailAuthFocus.dispose();
    _timerState ? _timer.cancel() : null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: EdgeInsets.only(top: 184.0.h, left: 16.0.w, right: 16.0.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '가입하신 이메일로\n로그인해 주세요.',
                style: TextStyle(
                  fontFamily: 'PretendardRegular',
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 68.0.h,
              ),
              Form(
                key: _emailAddressFormKey,
                child: CustomTextFormField(
                  focusNode: _emailAddressFocus,
                  labelText: '이메일',
                  hinText: '이메일을 입력해주세요.',
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    return _checkEmailAddressValid(value);
                  },
                  onChanged: (value) {
                    setState(() {
                      emailAddress = value;
                      _emailAddressFilled = value.isNotEmpty;
                    });
                  },
                  suffixIcon: Padding(
                    padding: EdgeInsets.only(
                        right: 16.0.w, top: 12.0.h, bottom: 12.0.h),
                    child: AuthenticationButton(onTap: () async {
                      await _emailVerifiedRequest();
                    }),
                  ),
                ),
              ),
              SizedBox(
                height: 18.0.h,
              ),
              Form(
                key: _emailAuthFormKey,
                child: CustomTextFormField(
                  focusNode: _emailAuthFocus,
                  labelText: '인증번호',
                  hinText: '인증번호를 입력해주세요.',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    return _checkEmailAuthValid(value);
                  },
                  onChanged: (value) {
                    setState(() {
                      authNumber = value;
                      _emailAuthFilled = value.isNotEmpty;
                    });
                  },
                  suffixIcon: Padding(
                    padding: EdgeInsets.only(right: 16.0.w),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${(remainingTime ~/ 60).toString().padLeft(2, '0')}:${(remainingTime % 60).toString().padLeft(2, '0')}',
                            style: TextStyle(
                              fontFamily: 'PretendardRegular',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              height: 1.43,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30.0.h,
              ),
              CompleteButton(
                  firstFieldState: _emailAddressFilled,
                  secondFieldState: _emailAuthFilled,
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    _emailAuthState =
                        await ApiService.checkOtp(authNumber, emailAddress);
                    if (!_emailAuthState) {
                      _handleEmailAuthValid();
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PageNavigator(),
                        ),
                      );
                    }
                  },
                  text: '로그인')
            ],
          ),
        ),
      ),
    );
  }
}
