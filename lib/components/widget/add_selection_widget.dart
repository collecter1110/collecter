import 'dart:io';
import 'package:collect_er/components/button/add_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../data/provider/collection_provider.dart';
import '../../data/provider/item_provider.dart';
import '../../data/provider/keyword_provider.dart';
import '../../data/services/api_service.dart';
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
  int? _collectionId;
  String? _title;
  List<Map<String, dynamic>>? _keywords;
  String? _description;
  List<String>? _imageFilePath;
  String? _link;
  List<Map<String, dynamic>>? _items;
  bool _isPrivate = false;
  String _inputKeywordValue = '';

  bool _isOrder = false;
  bool _itemState = false;

  int _itemNum = 0;

  final ImagePicker _picker = ImagePicker();
  List<XFile>? _mediaFileList;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> initializeData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final collectionProvider = context.read<CollectionProvider>();
      collectionProvider.resetCollectionIndex();

      final keywordProvider = context.read<KeywordProvider>();
      keywordProvider.clearKeywords();

      final itemProvider = context.read<ItemProvider>();
      itemProvider.clearItems();
    });
  }

  void _passFieldValidator() async {
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
          context.read<KeywordProvider>().keywordNames!);
      if (_mediaFileList != null && _mediaFileList!.isNotEmpty) {
        _imageFilePath =
            await ApiService.uploadAndGetImages(_mediaFileList!, 'selections');
      }
      await ApiService.addSelections(_collectionId!, _title!, _description,
          _imageFilePath, _keywords, _link, _items, _isOrder, _isPrivate);
      await context.read<CollectionProvider>().fetchCollections();
      context.read<KeywordProvider>().clearKeywords();
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
    PermissionStatus status = await Permission.photos.status;

    if (status.isGranted || status.isLimited) {
      final List<XFile> pickedFileList =
          await _picker.pickMultiImage(limit: 10);
      setState(() {
        _mediaFileList = pickedFileList;
      });
    } else {
      await Toast.handlePhotoPermission(status);
    }
  }

  Future<void> _createGroupDialog() async {
    await fetchCollections();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return CollectionTitleDialog();
      },
    );
  }

  Future<void> fetchCollections() async {
    final provider = context.read<CollectionProvider>();
    await provider.fetchCollections();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        FocusScope.of(context).unfocus();
        return false;
      },
      child: GestureDetector(
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
                padding:
                    EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0.w),
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
                            await _createGroupDialog();
                          },
                        ),
                      ],
                    ),
                    Consumer<CollectionProvider>(
                      builder: (context, provider, child) {
                        int? _collectionIndex = provider.collectionIndex;
                        String? _collectionName;

                        bool isSelected = false;

                        if (_collectionIndex != null) {
                          final collection =
                              provider.myCollections![_collectionIndex];
                          _collectionName = collection.title;
                          _collectionId = collection.id;
                          isSelected = true;
                        }
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0.h),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.0),
                              color: isSelected
                                  ? Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.3)
                                  : Colors.white,
                              border: Border.all(
                                color: isSelected
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
                                isSelected ? _collectionName! : '콜렉션을 선택해주세요.',
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.black
                                      : const Color(0xffADB5BD),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  height: 1.43,
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
                        keyboardType: TextInputType.name,
                        hintText: '셀렉션 이름',
                        isMultipleLine: false,
                        onSaved: (value) {
                          _title = value;
                        },
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
                          'ex) 다이어트, 로맨틱 코미디 ,추리물',
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
                                keyboardType: TextInputType.name,
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
                            _description = value ?? '';
                          },
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
                      child: _mediaFileList != null &&
                              _mediaFileList!.isNotEmpty
                          ? SizedBox(
                              height: 100.0.h,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: _mediaFileList!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return AspectRatio(
                                    aspectRatio: 0.9,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6.0),
                                      child: Image.file(
                                        File(
                                          _mediaFileList![index].path,
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
                          _link = value;
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
                              _isOrder ? '아이템 순서' : '아이템 리스트',
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
                                      : '링크 버튼을 눌러 링크를 추가해보세요.',
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
                        SizedBox(
                          width: 90.0.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AddButton(
                                onPressed: () {
                                  setState(() {
                                    FocusScope.of(context).unfocus();
                                    _itemState = true;
                                    _itemNum++;
                                  });
                                },
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
                                  trackOutlineColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0.h),
                      child: Column(
                        children: [
                          _itemState
                              ? ItemTextField(
                                  itemNum: _itemNum,
                                  orderState: _isOrder,
                                )
                              : SizedBox.shrink(),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _isPrivate ? '공유 가능' : '공유 불가능',
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
                            value: _isPrivate,
                            onChanged: (value) {
                              setState(() {
                                FocusScope.of(context).unfocus();
                                _isPrivate = value;
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
                            (_) {
                              final fieldValidator = FieldValidator({
                                '컬렉션 ID가 누락되었습니다': _collectionId != null,
                                '셀렉션 이름을 입력해주세요': _title?.isNotEmpty == true,
                                '키워드를 입력해주세요': context
                                        .read<KeywordProvider>()
                                        .keywordNames
                                        ?.isNotEmpty ==
                                    true,
                              });
                              if (!fieldValidator.validateFields()) {
                                return;
                              } else {
                                _passFieldValidator();
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

typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality, int? limit);
