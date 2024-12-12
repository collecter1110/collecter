import 'package:collecter/components/widget/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../components/button/add_button.dart';
import '../../components/button/complete_button.dart';
import '../../components/button/tag_button.dart';
import '../../components/pop_up/category_dialog.dart';
import '../../components/pop_up/collection_cover_dialog.dart';
import '../../components/pop_up/toast.dart';
import '../../components/text_field/add_text_form_field.dart';
import '../../components/ui_kit/custom_app_bar.dart';
import '../../data/model/category_model.dart';
import '../../data/model/collection_model.dart';
import '../../data/provider/category_provider.dart';
import '../../data/provider/selection_provider.dart';
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
  int? _userId;
  int? _categoryId;
  int? _collectionId;
  String? _changedTitle;
  String? _changedDescription;
  String? _initialImageName;
  String? _changedImageName;
  String? _finalImageFilePath;
  bool? _changedIsPublic;

  String _inputTagValue = '';
  List<CategoryModel> _categoryInfo = [];
  String? _categoryName;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  void initializeData() {
    final tagProvider = context.read<TagProvider>();
    final categoryProvider = context.read<CategoryProvider>();
    _categoryInfo = categoryProvider.categoryInfo;
    if (widget.collectionDetail.tags != null) {
      tagProvider.saveTags = widget.collectionDetail.tags!;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        tagProvider.clearTags();
      });
    }
    _userId = widget.collectionDetail.userId;
    _categoryId = widget.collectionDetail.categoryId;
    _categoryName = _categoryInfo
        .firstWhere((category) => category.categoryId == _categoryId)
        .categoryName;
    _collectionId = widget.collectionDetail.id;
    _changedTitle = widget.collectionDetail.title;
    _changedDescription = widget.collectionDetail.description;
    _initialImageName = widget.collectionDetail.imageFilePath;
    _changedIsPublic = widget.collectionDetail.isPublic;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _showGroupDialog() async {
    showModalBottomSheet(
      context: context,
      constraints: BoxConstraints(
        maxWidth: double.infinity,
      ),
      isScrollControlled: false,
      builder: (context) {
        return CategoryDialog(
          selectedCategoryId: _categoryId,
          saveCategory: (value) {
            setState(() {
              _categoryId = value.categoryId;
              _categoryName = _categoryInfo
                  .firstWhere((category) => category.categoryId == _categoryId)
                  .categoryName;
            });
          },
        );
      },
    );
  }

  Widget _buildImageWidget() {
    if (_changedImageName == 'default') {
      return _buildDefaultImage();
    }

    if (_changedImageName != null) {
      return ImageWidget(
        storageFolderName: '$_userId/selections',
        imageFilePath: _changedImageName!,
        boarderRadius: 8.r,
      );
    }

    if (_initialImageName != null) {
      return ImageWidget(
        storageFolderName: '$_userId/collections',
        imageFilePath: _initialImageName!,
        boarderRadius: 8.r,
      );
    }

    return _buildDefaultImage();
  }

  Widget _buildDefaultImage() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffF8F9FA),
        borderRadius: BorderRadius.circular(8.0.r),
      ),
      child: Center(
        child: SizedBox(
          height: 24.0.h,
          child: Image.asset(
            'assets/icons/tab_add.png',
            fit: BoxFit.contain,
            color: const Color(0xFF212529),
          ),
        ),
      ),
    );
  }

  Future<void> _passFieldValidator() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    try {
      if (!(_initialImageName ?? '').contains(_changedImageName ?? '')) {
        print('바꾸기');
        print('처음 $_initialImageName');
        print('바꾼후 $_changedImageName');

        if (_initialImageName != null) {
          print('스토리지 삭제');
          await ApiService.deleteStorageImages(
              'collections', [_initialImageName!]);
        }

        if (_changedImageName != 'default') {
          print('스토리지 등록');
          await ApiService.copyImageFilePath(
            'selections',
            'collections',
            _changedImageName!,
            widget.collectionDetail.id,
          );
          _finalImageFilePath =
              '${widget.collectionDetail.id}_${_changedImageName}';
        } else {
          _finalImageFilePath = null;
        }
      } else if ((_initialImageName ?? '').contains(_changedImageName ?? '') &&
          _changedImageName != null) {
        _finalImageFilePath =
            '${widget.collectionDetail.id}_${_changedImageName}';
      } else {
        _finalImageFilePath = _initialImageName;
      }
      print(_finalImageFilePath);

      await ApiService.editCollection(
        _categoryId!,
        widget.collectionDetail.id,
        _changedTitle!,
        _changedDescription,
        _finalImageFilePath,
        context.read<TagProvider>().tagNames,
        _changedIsPublic!,
      );
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

  Future<void> _showCoverImageDialog() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      builder: (context) {
        return CollectionCoverDialog(
          collectionId: _collectionId!,
          voidCallback: () async {
            final provider = context.read<SelectionProvider>();
            setState(() {
              _changedImageName = provider.collectionCoverImage;
            });
          },
        );
      },
    );
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
                              bool? isDefaultImage =
                                  await Toast.selectImageDialog(context);
                              setState(() {
                                if (isDefaultImage == true) {
                                  _changedImageName = 'default';
                                } else if (isDefaultImage == false) {
                                  _showCoverImageDialog();
                                }
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xFFdee2e6),
                                  width: 0.5.w,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.r),
                                ),
                              ),
                              width: 130.w,
                              child: AspectRatio(
                                aspectRatio: 0.9,
                                child: _buildImageWidget(),
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
                      '카테고리',
                      style: TextStyle(
                        fontFamily: 'PretendardRegular',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff343A40),
                        height: 1.5,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await _showGroupDialog();
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0.h),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0.r),
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.3),
                            border: Border.all(
                              color: Theme.of(context).primaryColor,
                              width: 1.0,
                              style: BorderStyle.solid,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 12.0.h, horizontal: 16.0.w),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _categoryName ?? '',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                height: 1.43,
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
                        keyboardType: TextInputType.text,
                        initialText: widget.collectionDetail.title,
                        isMultipleLine: false,
                        onSaved: (value) {
                          value == '' || value == null
                              ? _changedTitle = null
                              : _changedTitle = value;
                        },
                        inputFormatter: [LengthLimitingTextInputFormatter(30)],
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
                                keyboardType: TextInputType.multiline,
                                hintText: '태그 추가',
                                inputFormatter: [
                                  FilteringTextInputFormatter.deny(
                                      RegExp(r'\s'))
                                ],
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
                          inputFormatter: [
                            LengthLimitingTextInputFormatter(100)
                          ],
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
                          _changedIsPublic! ? '전체 공개' : '비공개',
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
                            value: _changedIsPublic!,
                            onChanged: (value) {
                              setState(() {
                                _changedIsPublic = value;
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
