import 'dart:io';
import 'package:collect_er/components/button/add_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../data/provider/keyword_provider.dart';
import '../button/complete_button.dart';
import '../button/keyword_button.dart';
import '../constants/screen_size.dart';
import '../text_field/Item_text_field.dart';
import '../text_field/add_text_form_field.dart';

class AddSelectionWidget extends StatefulWidget {
  const AddSelectionWidget({super.key});

  @override
  State<AddSelectionWidget> createState() => _AddSelectionWidgetState();
}

class _AddSelectionWidgetState extends State<AddSelectionWidget> {
  final GlobalKey<FormState> _keywordFormKey = GlobalKey<FormState>();
  bool _isPrivate = false;
  bool _isOrder = false;
  bool _itemState = false;
  String _inputKeywordValue = '';

  int _itemNum = 0;

  List<String> _titleName = [
    '나만의 레시피북',
    '다이어트 레시피',
    '여름 코디룩',
    '사고 싶은 화장품 리스트',
    '저소음 기계식 키보드 리스트',
    '읽은 책 목록',
    '읽고 싶은 책 목록',
  ];

  void _saveForm() {
    _keywordFormKey.currentState?.save();

    context.read<KeywordProvider>().addKeyword = _inputKeywordValue;
  }

  XFile? _image;
  final ImagePicker picker = ImagePicker();

  Future getImage(ImageSource imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    //FocusScope.of(context).unfocus();
    super.dispose();
  }

  void _createGroupDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
                color: Colors.white,
              ),
              height: screenHeight(context) * 1 / 2,
              width: double.infinity,
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 20.0.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'My Collection',
                          style: TextStyle(
                            fontFamily: 'PretendardRegular',
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            height: 1.2,
                          ),
                        ),
                        InkWell(
                          child: SizedBox(
                            height: 16.0.h,
                            child: Image.asset(
                              'assets/icons/button_delete.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0.h),
                        child: ListView.separated(
                          primary: false,
                          scrollDirection: Axis.vertical,
                          itemCount: _titleName.length,
                          itemBuilder: (context, index) {
                            return TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 12.0.h, horizontal: 16.0.w),
                                backgroundColor: index == 0
                                    ? Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.3)
                                    : Colors.white,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                minimumSize: Size.zero,
                                side: BorderSide(
                                  color: index == 0
                                      ? Theme.of(context).primaryColor
                                      : Color(0xFFf1f3f5),
                                  width: 1.0,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _titleName[index],
                                  style: TextStyle(
                                    color: index == 0
                                        ? Colors.black
                                        : Color(0xFFadb5bd),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    height: 1.43,
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              height: 8.0.h,
                            );
                          },
                        ),
                      ),
                    ),
                    CompleteButton(
                        firstFieldState: true,
                        secondFieldState: true,
                        onTap: () {
                          Navigator.pop(context);
                        },
                        text: '선택')
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                      '콜렉션 선택',
                      style: TextStyle(
                        fontFamily: 'PretendardRegular',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff343A40),
                        height: 1.5,
                      ),
                    ),
                    AddButton(
                      onPressed: () {
                        _createGroupDialog(context);
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0.h),
                  child: _image != null ? SizedBox() : SizedBox.shrink(),
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
                    onSaved: (string) {},
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
                      onSaved: (string) {},
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
                      setState(() {
                        getImage(ImageSource.gallery);
                      });
                    }),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0.h),
                  child: _image != null
                      ? SizedBox(
                          width: 80.0.w,
                          height: 80.0.h,
                          child: Image.file(File(_image!.path)),
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
                    onSaved: (string) {},
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
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
