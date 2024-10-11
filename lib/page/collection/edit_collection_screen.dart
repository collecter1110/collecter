import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../components/button/add_button.dart';
import '../../components/button/complete_button.dart';
import '../../components/button/tag_button.dart';
import '../../components/pop_up/toast.dart';
import '../../components/text_field/add_text_form_field.dart';
import '../../components/ui_kit/custom_app_bar.dart';
import '../../data/model/collection_model.dart';
import '../../data/provider/tag_provider.dart';
import '../../data/services/api_service.dart';

class EditCollectionScreen extends StatefulWidget {
  final CollectionModel collectionDetail;
  final VoidCallback callback;

  const EditCollectionScreen({
    super.key,
    required this.callback,
    required this.collectionDetail,
  });

  @override
  State<EditCollectionScreen> createState() => _EditCollectionScreenState();
}

class _EditCollectionScreenState extends State<EditCollectionScreen> {
  final GlobalKey<FormState> _tagFormKey = GlobalKey<FormState>();
  String? _changedTitle;
  String? _changedDescription;
  String? _changedImageFilePath;
  bool? _changedIsPrivate;

  String _inputTagValue = '';

  bool _isChangedImage = false;

  XFile? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  void initializeData() {
    final tagProvider = context.read<TagProvider>();

    if (widget.collectionDetail.tags != null) {
      tagProvider.saveTags = widget.collectionDetail.tags!;
    }
    _changedTitle = widget.collectionDetail.title;
    _changedDescription = widget.collectionDetail.description;
    _changedImageFilePath = widget.collectionDetail.imageFilePath;
    _pickedImage =
        _changedImageFilePath != null ? XFile(_changedImageFilePath!) : null;
    _changedIsPrivate = widget.collectionDetail.isPrivate;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildImageWidget() {
    if (_pickedImage == null) {
      return Container(
        color: Color(0xffF8F9FA),
        child: Center(
          child: SizedBox(
            height: 24.0.h,
            child: Image.asset(
              'assets/icons/tab_add.png',
              fit: BoxFit.contain,
              color: Color(0xFF212529),
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
              await ApiService.uploadAndGetImage(_pickedImage!, 'collections');
        } else {
          _changedImageFilePath = null;
        }
      }

      await ApiService.editCollection(
          widget.collectionDetail.id,
          _changedTitle!,
          _changedDescription,
          _changedImageFilePath,
          context.read<TagProvider>().tagNames,
          _changedIsPrivate!);
    } catch (e) {
      print('Error: $e');
    } finally {
      if (Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      if (mounted) {
        Navigator.pop(context);
        widget.callback();
      }
    }
  }

  void _saveForm() {
    _tagFormKey.currentState?.save();
    context.read<TagProvider>().addTag = _inputTagValue;
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
                              width: 100.w,
                              child: AspectRatio(
                                aspectRatio: 1 / 1,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  child: _buildImageWidget(),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.0.h),
                              child: Text(
                                '커버 변경',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.sp,
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
                      '컬렉션 이름',
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
                        initialText: widget.collectionDetail.title,
                        isMultipleLine: false,
                        onSaved: (value) {
                          value == '' || value == null
                              ? _changedTitle = null
                              : _changedTitle = value;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 26.0.h,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '태그',
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Form(
                              key: _tagFormKey,
                              child: AddTextFormField(
                                keyboardType: TextInputType.name,
                                hintText: '태그 추가',
                                formatter: FilteringTextInputFormatter.deny(
                                    RegExp(r'\s')),
                                isMultipleLine: false,
                                onSaved: (value) {
                                  _inputTagValue = value ?? '';
                                  FocusScope.of(context).unfocus();
                                  _tagFormKey.currentState?.reset();
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 16.0.w,
                          ),
                          AddButton(
                            onPressed: () {
                              _saveForm();
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.0.h),
                      child: Consumer<TagProvider>(
                        builder: (context, provider, child) {
                          return provider.tagNames != null
                              ? Wrap(
                                  direction: Axis.horizontal,
                                  alignment: WrapAlignment.start,
                                  spacing: 10.0.w,
                                  runSpacing: 5.0.h,
                                  children: provider.tagNames!
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    int index = entry.key;
                                    String keywords = entry.value;

                                    return TagButton(
                                      tagName: keywords,
                                      index: index,
                                    );
                                  }).toList(),
                                )
                              : SizedBox.shrink();
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
                          initialText: widget.collectionDetail.description,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _changedIsPrivate! ? '공개' : '비공개',
                          style: TextStyle(
                            fontFamily: 'PretendardRegular',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff343A40),
                            height: 1.5,
                          ),
                        ),
                        SizedBox(width: 10),
                        Transform.scale(
                          scale: 0.8,
                          child: Switch(
                            value: _changedIsPrivate!,
                            onChanged: (value) {
                              setState(() {
                                _changedIsPrivate = value;
                              });
                            },
                            inactiveThumbColor: Colors.white,
                            inactiveTrackColor: Color(0xffdee2e6),
                            activeTrackColor: Colors.black,
                            activeColor: Theme.of(context).primaryColor,
                            trackOutlineColor:
                                MaterialStateProperty.all(Colors.transparent),
                          ),
                        ),
                      ],
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
                              final fieldValidator = FieldValidator({
                                '컬렉션 이름을 입력해주세요':
                                    _changedTitle?.isNotEmpty == true,
                              });

                              if (!fieldValidator.validateFields()) {
                                return;
                              } else {
                                await _passFieldValidator();
                              }
                            },
                          );
                        }),
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
