import 'dart:async';

import 'package:collect_er/components/button/complete_button.dart';
import 'package:collect_er/data/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/button/authentication_button.dart';
import '../../components/text_field/custom_text_form_field.dart';
import 'set_user_info_screen.dart';

class EmailAuthenticationScreen extends StatefulWidget {
  const EmailAuthenticationScreen({Key? key}) : super(key: key);

  @override
  State<EmailAuthenticationScreen> createState() =>
      _EmailAuthenticationScreenState();
}

class _EmailAuthenticationScreenState extends State<EmailAuthenticationScreen> {
  bool _emailAddressFilled = false;
  bool _emailAddressDuplicate = false;
  bool _emailAddressValid = false;
  bool _emailVerifiedFilled = false;
  bool _emailVerifiedState = false;

  FocusNode _emailAddressFocus = FocusNode();
  FocusNode _emailVerifiedFocus = FocusNode();

  final _emailAddressFormKey = GlobalKey<FormState>();
  final _emailVerifiedFormKey = GlobalKey<FormState>();

  String emailAddress = '';
  String verifiedNumber = '';

  late Timer _timer;
  int remainingTime = 180;
  bool _timerState = false;

  @override
  void initState() {
    super.initState();

    _emailAddressFocus.addListener(() {
      setState(() {
        final formKeyState = _emailAddressFormKey.currentState!;
        if (formKeyState.validate()) {
          formKeyState.save();
        }
      });
    });
    _emailVerifiedFocus.addListener(() {
      setState(() {
        final formKeyState = _emailVerifiedFormKey.currentState!;
        if (formKeyState.validate()) {
          formKeyState.save();
        }
      });
    });
  }

  String? _checkEmailExist(String? value) {
    if (_emailAddressFocus.hasFocus) {
      _emailAddressDuplicate = true;
      _emailAddressValid = true;
      return null;
    }
    if (!_emailAddressDuplicate && _emailAddressFilled) {
      return '이미 존재하는 이메일입니다.';
    }
    if (!_emailAddressValid && _emailAddressFilled) {
      return '이메일 형식이 아닙니다.';
    }
  }

  String? _checkEmailVerified(String? value) {
    if (_emailVerifiedFocus.hasFocus) {
      _emailVerifiedState = true;
      return null;
    }
    if (!_emailVerifiedState && _emailVerifiedFilled) {
      return '인증번호가 올바르지 않습니다.';
    } else {
      return null;
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

  @override
  void dispose() {
    _emailAddressFocus.dispose();
    _emailVerifiedFocus.dispose();
    _timer.cancel();
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
          padding: EdgeInsets.symmetric(horizontal: 16.0.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: _emailAddressFormKey,
                child: CustomTextFormField(
                  focusNode: _emailAddressFocus,
                  labelText: '이메일',
                  hinText: '이메일을 입력해주세요.',
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    return _checkEmailExist(value);
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
                      FocusScope.of(context).unfocus();
                      print('이메일 주소 $emailAddress');
                      _emailAddressDuplicate =
                          await ApiService.checkEmailDuplicate(emailAddress);
                      print(_emailAddressDuplicate);
                      if (!_emailAddressDuplicate) {
                        final formKeyState = _emailAddressFormKey.currentState!;
                        if (formKeyState.validate()) {
                          formKeyState.save();
                        }
                      } else {
                        _emailAddressValid =
                            await ApiService.sendOtp(emailAddress);

                        if (!_emailAddressValid) {
                          final formKeyState =
                              _emailAddressFormKey.currentState!;
                          if (formKeyState.validate()) {
                            formKeyState.save();
                          }
                        } else {
                          FocusScope.of(context)
                              .requestFocus(_emailVerifiedFocus);
                          startTimer();
                        }
                      }
                    }),
                  ),
                ),
              ),
              SizedBox(
                height: 12.0.h,
              ),
              Form(
                key: _emailVerifiedFormKey,
                child: CustomTextFormField(
                  focusNode: _emailVerifiedFocus,
                  labelText: '인증번호',
                  hinText: '인증번호를 입력해주세요.',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    return _checkEmailVerified(value);
                  },
                  onChanged: (value) {
                    setState(() {
                      verifiedNumber = value;
                      _emailVerifiedFilled = value.isNotEmpty;
                    });
                  },
                  suffixIcon: Padding(
                    padding: EdgeInsets.only(
                        right: 16.0.w, top: 12.0.h, bottom: 12.0.h),
                    child: Text(
                      '${(remainingTime ~/ 60).toString().padLeft(2, '0')}:${(remainingTime % 60).toString().padLeft(2, '0')}',
                      style: TextStyle(
                          fontFamily: 'PretendardRegular',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0.h,
              ),
              CompleteButton(
                  firstFieldState: _emailAddressFilled,
                  secondFieldState: _emailVerifiedFilled,
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    _emailVerifiedState =
                        await ApiService.checkOtp(verifiedNumber, emailAddress);
                    if (!_emailVerifiedState) {
                      final formKeyState = _emailVerifiedFormKey.currentState!;
                      if (formKeyState.validate()) {
                        formKeyState.save();
                      }
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SetUserInfoScreen(email: emailAddress),
                        ),
                      );
                    }
                  },
                  text: '회원가입')
            ],
          ),
        ),
      ),
    );
  }
}
