import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../data/provider/collection_provider.dart';
import '../../data/provider/item_provider.dart';
import '../../data/provider/keyword_provider.dart';
import '../../data/services/api_service.dart';
import '../button/add_button.dart';
import '../button/complete_button.dart';
import '../button/keyword_button.dart';
import '../pop_up/collection_title_dialog.dart';
import '../pop_up/toast.dart';
import '../text_field/Item_text_field.dart';
import '../text_field/add_text_form_field.dart';

class AddSelectionWidget extends StatefulWidget {
  const AddSelectionWidget({super.key});

  @override
  State<AddSelectionWidget> createState() => _AddSelectionWidgetState();
}

class _AddSelectionWidgetState extends State<AddSelectionWidget> {
  final GlobalKey<FormState> _keywordFormKey = GlobalKey<FormState>();
  int? _categoryId;
  int? _collectionId;
  String? _title;
  List<Map<String, dynamic>>? _keywords;
  String? _description;
  List<String>? _imageFilePaths;
  String? _link;
  List<Map<String, dynamic>>? _items;
  bool _isSelectable = true;
  String _inputKeywordValue = '';

  bool _isOrder = false;
  bool _itemState = false;

  int _itemIndex = 0;

  final ImagePicker _picker = ImagePicker();
  List<XFile>? _picekdImages;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initializeData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final keywordProvider = context.read<KeywordProvider>();
      keywordProvider.clearKeywords();

      final itemProvider = context.read<ItemProvider>();
      itemProvider.clearItems();
    });
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
      _items = context.read<ItemProvider>().itemDataListToJson();
      _keywords = await ApiService.addKeywords(
          context.read<KeywordProvider>().keywordNames!, _categoryId!);
      if (_picekdImages != null && _picekdImages!.isNotEmpty) {
        _imageFilePaths = await ApiService.uploadAndGetImageFilePaths(
            _picekdImages!, 'selections');
      }
      await ApiService.addSelections(
          _categoryId!,
          _collectionId!,
          _title!,
          _description,
          _imageFilePaths,
          _keywords!,
          _link,
          _items,
          _isOrder,
          _isSelectable);
    } catch (e) {
      print('Error: $e');
    } finally {
      if (Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/bookmark',
          (Route<dynamic> route) => false,
        );
      }
    }
  }

  void _saveForm() {
    _keywordFormKey.currentState?.save();
    context.read<KeywordProvider>().addKeyword = _inputKeywordValue;
  }

  Future _pickImages() async {
    final List<XFile> pickedFileList = await _picker.pickMultiImage(limit: 2);
    setState(() {
      _picekdImages = pickedFileList;
    });
  }

  Future<void> _showGroupDialog() async {
    showModalBottomSheet(
      context: context,
      constraints: BoxConstraints(
        maxWidth: double.infinity,
      ),
      isScrollControlled: false,
      builder: (context) {
        return CollectionTitleDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 12.0.h,
              color: Color(0xFFf5f5f5),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '컬렉션 선택',
                        style: TextStyle(
                          fontFamily: 'PretendardRegular',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff343A40),
                          height: 1.5,
                        ),
                      ),
                      AddButton(
                        onPressed: () async {
                          await _showGroupDialog();
                        },
                      ),
                    ],
                  ),
                  Selector<CollectionProvider,
                      ({String? item1, int? item2, int? item3})>(
                    selector: (context, collectionProvider) => (
                      item1: collectionProvider.collectionTitle,
                      item2: collectionProvider.collectionId,
                      item3: collectionProvider.categoryId
                    ),
                    builder: (context, data, child) {
                      String? _collectionTitle = data.item1;
                      _collectionId = data.item2;
                      _categoryId = data.item3;

                      return InkWell(
                        onTap: () async {
                          await _showGroupDialog();
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0.h),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0.r),
                              color: _collectionTitle != null
                                  ? Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.3)
                                  : Colors.white,
                              border: Border.all(
                                color: _collectionTitle != null
                                    ? Theme.of(context).primaryColor
                                    : const Color(0xFFf1f3f5),
                                width: 1.0,
                                style: BorderStyle.solid,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 12.0.h, horizontal: 16.0.w),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _collectionTitle != null
                                    ? '${_collectionTitle}'
                                    : '컬렉션을 선택해주세요.',
                                style: TextStyle(
                                  color: _collectionTitle != null
                                      ? Colors.black
                                      : const Color(0xffADB5BD),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  height: 1.43,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 20.0.h,
                  ),
                  Text(
                    '셀렉션 이름',
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
                      hintText: '셀렉션 이름',
                      isMultipleLine: false,
                      onSaved: (value) {
                        value == '' || value == null
                            ? _title = null
                            : _title = value;
                      },
                      inputFormatter: [LengthLimitingTextInputFormatter(30)],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '키워드 추가',
                    style: TextStyle(
                      fontFamily: 'PretendardRegular',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff343A40),
                      height: 1.5,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.0.h),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'ex) 레시피, 영화, 책 등의 단어로 입력해주세요.',
                        style: TextStyle(
                          fontFamily: 'PretendardRegular',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: Color(0xffADB5BD),
                          height: 1.5,
                        ),
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
                            key: _keywordFormKey,
                            child: AddTextFormField(
                              keyboardType: TextInputType.text,
                              hintText: '키워드 추가',
                              isMultipleLine: false,
                              onSaved: (value) {
                                _inputKeywordValue = value ?? '';
                                FocusScope.of(context).unfocus();
                                _keywordFormKey.currentState?.reset();
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
                    child: Consumer<KeywordProvider>(
                      builder: (context, provider, child) {
                        return provider.keywordNames != null
                            ? Wrap(
                                direction: Axis.horizontal,
                                alignment: WrapAlignment.start,
                                spacing: 10.0.w,
                                runSpacing: 5.0.h,
                                children: provider.keywordNames!
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  int index = entry.key;
                                  String keywords = entry.value;

                                  return KeywordButton(
                                    keywordName: keywords,
                                    index: index,
                                  );
                                }).toList(),
                              )
                            : SizedBox.shrink();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '설명 (선택)',
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
                    child: SizedBox(
                      height: 80.0.h,
                      child: AddTextFormField(
                        keyboardType: TextInputType.multiline,
                        hintText: '설명',
                        isMultipleLine: true,
                        onSaved: (value) {
                          value == '' || value == null
                              ? _description = null
                              : _description = value;
                        },
                        inputFormatter: [LengthLimitingTextInputFormatter(300)],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '사진 추가 (선택)',
                        style: TextStyle(
                          fontFamily: 'PretendardRegular',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff343A40),
                          height: 1.5,
                        ),
                      ),
                      AddButton(onPressed: () {
                        _pickImages();
                      }),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0.h),
                    child: _picekdImages != null && _picekdImages!.isNotEmpty
                        ? SizedBox(
                            height: 100.0.h,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: _picekdImages!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return AspectRatio(
                                  aspectRatio: 0.9,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r),
                                      border: Border.all(
                                        color: Color(0xFFdee2e6),
                                        width: 0.5.w,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(8.0.r),
                                      child: Image.file(
                                        File(
                                          _picekdImages![index].path,
                                        ),
                                        fit: BoxFit.cover,
                                        errorBuilder: (BuildContext context,
                                            Object error,
                                            StackTrace? stackTrace) {
                                          return const Center(
                                              child: Text(
                                                  'This image type is not supported'));
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox(
                                  width: 10.0.w,
                                );
                              },
                            ),
                          )
                        : SizedBox.shrink(),
                  ),
                  SizedBox(
                    height: 20.0.h,
                  ),
                  Text(
                    '관련 링크 추가 (선택)',
                    style: TextStyle(
                      fontFamily: 'PretendardRegular',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff343A40),
                      height: 1.5,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.0.h),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'ex) https://www.youtube.com/',
                        style: TextStyle(
                          fontFamily: 'PretendardRegular',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: Color(0xffADB5BD),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0.h),
                    child: AddTextFormField(
                      keyboardType: TextInputType.url,
                      hintText: 'url 추가',
                      isMultipleLine: false,
                      onSaved: (value) {
                        value == '' || value == null
                            ? _link = null
                            : _link = value;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20.0.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isOrder ? '아이템 순서 (선택)' : '아이템 리스트 (선택)',
                            style: TextStyle(
                              fontFamily: 'PretendardRegular',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff343A40),
                              height: 1.5,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.0.h),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _isOrder
                                    ? '아이템을 꾹 눌러서 순서를 변경해보세요.'
                                    : '오른쪽 토글을 눌러 순서를 설정하세요.',
                                style: TextStyle(
                                  fontFamily: 'PretendardRegular',
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xffADB5BD),
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ValueListenableBuilder<int>(
                              valueListenable:
                                  context.watch<ItemProvider>().countNotifier,
                              builder: (context, itemNum, child) {
                                return AddButton(
                                  onPressed: () {
                                    setState(() {
                                      FocusScope.of(context).unfocus();
                                      if (itemNum >= 9) {
                                        Toast.notify('아이템은 최대 9개까지 추가가 가능합니다.');
                                        return;
                                      } else {
                                        _itemIndex++;
                                        _itemState = true;
                                      }
                                    });
                                  },
                                );
                              }),
                          SizedBox(
                            width: 10.0.w,
                          ),
                          Transform.scale(
                            scale: 0.8,
                            child: Switch(
                              value: _isOrder,
                              onChanged: (value) {
                                setState(() {
                                  FocusScope.of(context).unfocus();
                                  _isOrder = value;
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
                    ],
                  ),
                  Column(
                    children: [
                      _itemState
                          ? Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0.h),
                              child: ItemTextField(
                                itemNum: _itemIndex,
                                orderState: _isOrder,
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                  SizedBox(
                    height: 20.0.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isSelectable ? '셀렉팅 허용' : '셀렉팅 제한',
                            style: TextStyle(
                              fontFamily: 'PretendardRegular',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff343A40),
                              height: 1.5,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.0.h),
                            child: Text(
                              '공유 가능 상태를 설정합니다.',
                              style: TextStyle(
                                fontFamily: 'PretendardRegular',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xffADB5BD),
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 10),
                      Transform.scale(
                        scale: 0.8,
                        child: Switch(
                          value: _isSelectable,
                          onChanged: (value) {
                            setState(() {
                              FocusScope.of(context).unfocus();
                              _isSelectable = value;
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
                    height: 40.0.h,
                  ),
                  CompleteButton(
                      firstFieldState: true,
                      secondFieldState: true,
                      text: '저장',
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        WidgetsBinding.instance.addPostFrameCallback(
                          (_) async {
                            final fieldValidator = FieldValidator({
                              '컬렉션을 선택해주세요.': _collectionId != null,
                              '셀렉션 이름을 입력해주세요.': _title?.isNotEmpty == true,
                              '키워드를 입력해주세요.': context
                                      .read<KeywordProvider>()
                                      .keywordNames
                                      ?.isNotEmpty ==
                                  true,
                              '비어있는 아이템이 있습니다.': context
                                      .read<ItemProvider>()
                                      .hasNullItemTitle() ==
                                  false
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
    );
  }
}
