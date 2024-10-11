import 'dart:io';
import 'package:collect_er/data/model/user_info_model.dart';
import 'package:collect_er/data/provider/user_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../components/button/complete_button.dart';
import '../../components/pop_up/toast.dart';
import '../../components/text_field/add_text_form_field.dart';
import '../../components/ui_kit/custom_app_bar.dart';
import '../../data/services/api_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    super.key,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String? _initialName;

  String? _changedEmail;
  String? _changedName;
  String? _changedDescription;
  String? _changedImageFilePath;

  bool _isChangedImage = false;

  XFile? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  void initializeData() {
    final provider = context.read<UserInfoProvider>();
    final UserInfoModel _userInfo = provider.userInfo!;
    _changedEmail = _userInfo.email!;
    _initialName = _userInfo.name;
    _changedName = _userInfo.name;
    _changedDescription = _userInfo.description;
    _changedImageFilePath = _userInfo.imageFilePath;
    _pickedImage =
        _changedImageFilePath != null ? XFile(_changedImageFilePath!) : null;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildImageWidget() {
    if (_pickedImage == null) {
      return Container(
        color: Color(0xFFf1f3f5),
        child: Center(
          child: SizedBox(
            width: 36.0.w,
            child: Image.asset(
              'assets/icons/tab_user.png',
              color: Colors.white,
              fit: BoxFit.contain,
            ),
          ),
        ),
      );
    } else if (!_isChangedImage) {
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(_changedImageFilePath!),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else if (_isChangedImage) {
      return Image.file(
        File(_pickedImage!.path),
        fit: BoxFit.cover,
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) {
          return const Center(
            child: Text('This image type is not supported'),
          );
        },
      );
    } else {
      return Container(
        color: Color(0xffF8F9FA),
        child: Center(child: Text('Error: Invalid state')),
      );
    }
  }

  Future<void> _passFieldValidator() async {
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
      if (_isChangedImage) {
        if (_pickedImage != null) {
          _changedImageFilePath =
              await ApiService.uploadAndGetImage(_pickedImage!, 'user');
        } else {
          _changedImageFilePath = null;
        }
      }

      await ApiService.editUserInfo(
          _changedName!, _changedDescription, _changedImageFilePath);
      final provider = context.read<UserInfoProvider>();
      await provider.fetchUserInfo();
    } catch (e) {
      print('Error: $e');
    } finally {
      if (Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future _pickImages(ImageSource imageSource) async {
    PermissionStatus status = await Permission.photos.request();

    if (status.isGranted || status.isLimited) {
      _pickedImage = await _picker.pickImage(source: imageSource);

      if (_pickedImage != null) {
        setState(() {
          _pickedImage = XFile(_pickedImage!.path);
        });
      }
    } else {
      await Toast.handlePhotoPermission(status);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        titleText: '수정',
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 26.0.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              _isChangedImage = true;
                              bool? isDefaultImage =
                                  await Toast.selectImageDialog(context);
                              if (isDefaultImage != null) {
                                if (isDefaultImage) {
                                  setState(() {
                                    _pickedImage = null;
                                    _changedImageFilePath = null;
                                  });
                                } else if (!isDefaultImage) {
                                  await _pickImages(ImageSource.gallery);
                                }
                              }
                            },
                            child: Container(
                              width: 80.w,
                              child: AspectRatio(
                                aspectRatio: 1 / 1,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                      child: SizedBox(
                                        width: 80.w,
                                        height: 80.0.w,
                                        child: _buildImageWidget(),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0.0.w,
                                      bottom: 0.0.h,
                                      child: Container(
                                        width: 26.0.w,
                                        height: 26.0.w,
                                        decoration: BoxDecoration(
                                          color: Color(0xFF495057),
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 4.0.w,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(3.0.w),
                                          child: Image.asset(
                                            'assets/icons/icon_plus.png',
                                            color: Colors.white,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0.h),
                              child: Text(
                                '프로필 수정',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.sp,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 26.0.h,
                    ),
                    Text(
                      '이메일',
                      style: TextStyle(
                        fontFamily: 'PretendardRegular',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff343A40),
                        height: 1.5,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0.h),
                      child: Container(
                        height: 48.0.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Color(0xffF5F6F7),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 14.0.w, vertical: 12.0.h),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                _changedEmail!,
                                style: TextStyle(
                                  color: Color(0xffADB5BD),
                                  fontSize: 14.0.sp,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w500,
                                  height: 1.43,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 26.0.h,
                    ),
                    Text(
                      '이름',
                      style: TextStyle(
                        fontFamily: 'PretendardRegular',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff343A40),
                        height: 1.5,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0.h),
                      child: AddTextFormField(
                        keyboardType: TextInputType.name,
                        initialText: _initialName,
                        isMultipleLine: false,
                        onSaved: (value) {
                          value == '' || value == null
                              ? _changedName = null
                              : _changedName = value;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 26.0.h,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '설명',
                        style: TextStyle(
                          fontFamily: 'PretendardRegular',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff343A40),
                          height: 1.5,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0.h),
                      child: SizedBox(
                        height: 80.0.h,
                        child: AddTextFormField(
                          keyboardType: TextInputType.multiline,
                          hintText: '설명을 추가해주세요.',
                          initialText: _changedDescription,
                          isMultipleLine: true,
                          onSaved: (value) {
                            value == '' || value == null
                                ? _changedDescription = null
                                : _changedDescription = value;
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 26.0.h,
                    ),
                    CompleteButton(
                      firstFieldState: true,
                      secondFieldState: true,
                      text: '수정 완료',
                      onTap: () {
                        FocusScope.of(context).unfocus();

                        WidgetsBinding.instance.addPostFrameCallback(
                          (_) async {
                            final Map<String, bool> conditions = {
                              '이름을 입력해주세요': _changedName?.isNotEmpty == true,
                            };
                            if (_changedName != null &&
                                _changedName!.isNotEmpty &&
                                _changedName != _initialName) {
                              bool isDuplicate =
                                  await ApiService.checkUserNameDuplicate(
                                      _changedName!);
                              if (!isDuplicate) {
                                conditions['이미 사용 중인 이름입니다'] = false;
                              }
                            }

                            final fieldValidator = FieldValidator(conditions);

                            if (!fieldValidator.validateFields()) {
                              return;
                            } else {
                              await _passFieldValidator();
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
