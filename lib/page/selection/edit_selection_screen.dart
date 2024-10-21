import 'dart:io';
import 'package:collect_er/components/button/keyword_button.dart';
import 'package:collect_er/data/model/item_model.dart';
import 'package:collect_er/data/provider/keyword_provider.dart';
import 'package:collect_er/data/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../components/button/add_button.dart';
import '../../components/button/complete_button.dart';
import '../../components/pop_up/toast.dart';
import '../../components/text_field/Item_text_field.dart';
import '../../components/text_field/add_text_form_field.dart';
import '../../components/ui_kit/custom_app_bar.dart';
import '../../data/model/selection_model.dart';
import '../../data/provider/item_provider.dart';
import '../../data/services/data_management.dart';

class EditSelectionScreen extends StatefulWidget {
  final SelectionModel selectionDetail;
  final VoidCallback callback;

  const EditSelectionScreen({
    super.key,
    required this.callback,
    required this.selectionDetail,
  });

  @override
  State<EditSelectionScreen> createState() => _EditSelectionScreenState();
}

class _EditSelectionScreenState extends State<EditSelectionScreen> {
  final GlobalKey<FormState> _keywordFormKey = GlobalKey<FormState>();
  String? _changedTitle;
  String? _changedDescription;
  String? _changedLink;
  bool? _changedIsOrder;
  bool? _changedIsPrivate;
  List<Map<String, dynamic>>? _changedKeywords;
  int _itemNum = 0;
  List<Map<String, dynamic>>? _changedItems;

  List<String> _initialImagePaths = [];
  List<String> _changedImagePaths = [];
  List<String> _deletedImages = [];
  List<ItemData>? _initialItemData;

  String _inputKeywordValue = '';

  XFile? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  int _imageNum = 0;

  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  void initializeData() {
    _changedTitle = widget.selectionDetail.title;
    _changedDescription = widget.selectionDetail.description;
    _changedLink = widget.selectionDetail.link;
    _changedIsPrivate = widget.selectionDetail.isSelectable;
    _changedIsOrder = widget.selectionDetail.isOrdered;
    _initialImagePaths = widget.selectionDetail.imageFilePaths != null
        ? List<dynamic>.from(widget.selectionDetail.imageFilePaths!)
            .cast<String>()
        : [];
    _changedImagePaths = List<String>.from(_initialImagePaths);

    _imageNum = _changedImagePaths.length;

    final keywordProvider = context.read<KeywordProvider>();
    if (widget.selectionDetail.keywords != null) {
      keywordProvider.saveKeywords = widget.selectionDetail.keywords!;
    }

    final itemProvider = context.read<ItemProvider>();
    itemProvider.clearItems();
    _itemNum = widget.selectionDetail.items != null
        ? widget.selectionDetail.items!.length
        : 0;
    _initialItemData = widget.selectionDetail.items;
    itemProvider.saveInitialItem = _initialItemData ?? [];
    final List<int> _itemOrder =
        _initialItemData?.map((item) => item.itemOrder).toList() ?? [];
    itemProvider.saveItemOrder = _itemOrder;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool _isNetworkImage(String imagePath) {
    return _initialImagePaths.contains(imagePath);
  }

  Future<List<String>> _uploadAndGetImageNames(List<dynamic> imagePaths) async {
    List<XFile> localImages = imagePaths
        .where((imagePath) => !_isNetworkImage(imagePath))
        .map((path) => XFile(path))
        .toList();

    List<String> finalImagePaths = imagePaths
        .where((imagePath) => _isNetworkImage(imagePath))
        .cast<String>()
        .toList();

    if (localImages.isNotEmpty) {
      List<String> uploadedImageUrls =
          await ApiService.uploadAndGetImageFilePaths(
              localImages, 'selections');
      finalImagePaths.addAll(uploadedImageUrls);
    }

    return finalImagePaths;
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
      _changedItems = context.read<ItemProvider>().itemDataListToJson();
      _changedKeywords = await ApiService.addKeywords(
          context.read<KeywordProvider>().keywordNames!);
      if (_deletedImages.isNotEmpty) {
        ApiService.deleteStorageImages('selections', _deletedImages);
      }
      List<String>? _changedImageFilePaths = _changedImagePaths.isNotEmpty
          ? await _uploadAndGetImageNames(_changedImagePaths)
          : null;

      await ApiService.editSelection(
        widget.selectionDetail.collectionId,
        widget.selectionDetail.selectionId,
        _changedTitle!,
        _changedDescription,
        _changedImageFilePaths,
        _changedKeywords!,
        _changedLink,
        _changedItems,
        _changedIsOrder!,
        _changedIsPrivate!,
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
    _keywordFormKey.currentState?.save();
    context.read<KeywordProvider>().addKeyword = _inputKeywordValue;
  }

  Future _pickImages(ImageSource imageSource) async {
    PermissionStatus status = await Permission.photos.request();

    if (status.isGranted || status.isLimited) {
      _pickedImage = await _picker.pickImage(source: imageSource);

      if (_pickedImage != null) {
        setState(() {
          _changedImagePaths.insert(
              _changedImagePaths.length, _pickedImage!.path);

          _imageNum = _changedImagePaths.length;
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
      body: NotificationListener<ScrollNotification>(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1 / 1,
                  child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      scrollDirection: Axis.horizontal,
                      physics: PageScrollPhysics(),
                      itemCount: _imageNum + 1,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0.w, vertical: 16.0.h),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            child: index == _imageNum
                                ? InkWell(
                                    onTap: () async {
                                      if (index == _imageNum &&
                                          _imageNum <= 4) {
                                        await _pickImages(ImageSource.gallery);
                                      } else {
                                        Toast.notify('최대 사진 개수를 초과했습니다.');
                                      }
                                    },
                                    child: Container(
                                      color: Color(0xFFf1f3f5),
                                      child: Center(
                                        child: SizedBox(
                                          height: 26.0.h,
                                          child: Image.asset(
                                            'assets/icons/tab_add.png',
                                            fit: BoxFit.contain,
                                            color: Color(0xFF343a40),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Stack(
                                    children: [
                                      _isNetworkImage(_changedImagePaths[index])
                                          ? Container(
                                              height: double.infinity,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                    DataManagement.getFullImageUrl(
                                                        '${widget.selectionDetail.ownerId}/selections',
                                                        _changedImagePaths[
                                                            index]),
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            )
                                          : Image.file(
                                              height: double.infinity,
                                              width: double.infinity,
                                              File(_changedImagePaths[index]),
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (BuildContext context,
                                                      Object error,
                                                      StackTrace? stackTrace) {
                                                return const Center(
                                                  child: Text(
                                                      'This image type is not supported'),
                                                );
                                              },
                                            ),
                                      Positioned(
                                        bottom: 14.0.h,
                                        left: 14.0.w,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              _deletedImages.add(
                                                  _changedImagePaths[index]);
                                              _changedImagePaths
                                                  .removeAt(index);
                                              _imageNum--;
                                            });
                                          },
                                          child: Container(
                                            child: Padding(
                                              padding: EdgeInsets.all(7.0.h),
                                              child: Image.asset(
                                                'assets/icons/icon_trash.png',
                                                color: Colors.white,
                                                fit: BoxFit.contain,
                                                height: 12.0.h,
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.black
                                                    .withOpacity(0.5)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        );
                      }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _imageNum + 1,
                    (index) => Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.0.w),
                      child: Container(
                        width: 7.0.h,
                        height: 7.0.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? Color(0xFF212529)
                              : Color(0xFFdee2e6),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 16.0.w, vertical: 26.0.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                          initialText: _changedTitle,
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
                          '키워드',
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
                                key: _keywordFormKey,
                                child: AddTextFormField(
                                  keyboardType: TextInputType.name,
                                  hintText: '키워드 추가',
                                  formatter: FilteringTextInputFormatter.deny(
                                      RegExp(r'\s')),
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
                      Text(
                        '링크 수정',
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
                          keyboardType: TextInputType.url,
                          initialText: _changedLink,
                          hintText: 'url 추가',
                          isMultipleLine: false,
                          onSaved: (value) {
                            value == '' || value == null
                                ? _changedLink = null
                                : _changedLink = value;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 26.0.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _changedIsOrder! ? '아이템 순서' : '아이템 리스트',
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
                                    _changedIsOrder!
                                        ? '아이템을 꾹 눌러서 순서를 변경해보세요.'
                                        : '오른쪽 버튼을 눌러 순서를 설정하세요.',
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
                                      _itemNum++;
                                    });
                                  },
                                ),
                                Transform.scale(
                                  scale: 0.8,
                                  child: Switch(
                                    value: _changedIsOrder!,
                                    onChanged: (value) {
                                      setState(() {
                                        FocusScope.of(context).unfocus();
                                        _changedIsOrder = value;
                                      });
                                    },
                                    inactiveThumbColor: Colors.white,
                                    inactiveTrackColor: Color(0xffdee2e6),
                                    activeTrackColor: Colors.black,
                                    activeColor: Theme.of(context).primaryColor,
                                    trackOutlineColor:
                                        MaterialStateProperty.all(
                                            Colors.transparent),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0.h),
                            child: ItemTextField(
                              initialItemValue: _initialItemData,
                              itemNum: _itemNum,
                              orderState: _changedIsOrder!,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 26.0.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _changedIsPrivate! ? '공유 가능' : '공유 불가능',
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
                                  '셀렉션 이름을 입력해주세요':
                                      _changedTitle?.isNotEmpty == true,
                                  '키워드를 입력해주세요': context
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
        ),
      ),
    );
  }
}
