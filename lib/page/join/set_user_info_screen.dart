import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/button/complete_button.dart';
import '../../components/text_field/custom_text_form_field.dart';
import '../../data/services/api_service.dart';
import '../../page_navigator.dart';

class SetUserInfoScreen extends StatefulWidget {
  final String email;
  const SetUserInfoScreen({
    super.key,
    required this.email,
  });

  @override
  State<SetUserInfoScreen> createState() => _SetUserInfoScreenState();
}

class _SetUserInfoScreenState extends State<SetUserInfoScreen> {
  bool _userNameFilled = false;
  bool _userNameExist = false;
  bool _userInfoUpdate = false;

  FocusNode _userNameFocus = FocusNode();

  TextEditingController _userDescriptionController = TextEditingController();

  final _userNameFormKey = GlobalKey<FormState>();

  String userName = '';
  String userDescription = '';

  @override
  void initState() {
    super.initState();

    _userNameFocus.addListener(() {
      setState(() {
        final formKeyState = _userNameFormKey.currentState!;
        if (formKeyState.validate()) {
          formKeyState.save();
        }
      });
    });
  }

  String? _checkUserNameValid(String? value) {
    if (_userNameFocus.hasFocus) {
      _userNameExist = true;
      return null;
    }
    if (!_userNameExist && _userNameFilled) {
      return '이미 존재하는 이름입니다.';
    }
  }

  @override
  void dispose() {
    _userNameFocus.dispose();
    _userDescriptionController.dispose();
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
                key: _userNameFormKey,
                child: CustomTextFormField(
                  inputFormatter: [
                    FilteringTextInputFormatter.allow(
                      RegExp(
                        r'^[a-zA-Z0-9_.]*$', // 영문, 숫자, 밑줄, 마침표만 허용
                      ),
                    ),
                    LengthLimitingTextInputFormatter(10),
                  ],
                  focusNode: _userNameFocus,
                  labelText: '이름',
                  hinText: '영문, 숫자, 밑줄, 마침표 포함 10자 이내',
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    return _checkUserNameValid(value);
                  },
                  onChanged: (value) {
                    setState(() {
                      userName = value;
                      _userNameFilled = value.isNotEmpty;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 12.0.h,
              ),
              CustomTextFormField(
                controller: _userDescriptionController,
                labelText: '설명',
                hinText: '설명을 입력해주세요 (선택)',
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 20.0.h,
              ),
              CompleteButton(
                  firstFieldState: _userNameFilled,
                  secondFieldState: true,
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    _userNameExist =
                        await ApiService.checkUserNameExist(userName);

                    if (!_userNameExist) {
                      final formKeyState = _userNameFormKey.currentState!;
                      if (formKeyState.validate()) {
                        formKeyState.save();
                      }
                    } else {
                      bool updateUserInfoState =
                          await ApiService.updateUserInfo(widget.email,
                              userName, _userDescriptionController.text);
                      if (updateUserInfoState) {
                        print(widget.email);

                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PageNavigator(),
                            ),
                          );
                        });
                      }
                    }
                  },
                  text: '완료')
            ],
          ),
        ),
      ),
    );
  }
}
