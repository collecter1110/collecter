import 'dart:io';
import 'package:collect_er/components/button/add_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../data/provider/keyword_provider.dart';
import '../button/complete_button.dart';
import '../button/keyword_button.dart';
import '../text_field/Item_text_field.dart';

class AddSelectionWidget extends StatefulWidget {
  const AddSelectionWidget({super.key});

  @override
  State<AddSelectionWidget> createState() => _AddSelectionWidgetState();
}

class _AddSelectionWidgetState extends State<AddSelectionWidget> {
  TextEditingController _keywordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _linkController = TextEditingController();
  bool _isPrivate = false;
  bool _isOrder = false;
  bool _itemState = false;

  int _itemNum = 0;

  final TextStyle _hintTextStyle = TextStyle(
    color: Color(0xffADB5BD),
    fontSize: 14.0.sp,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w500,
    height: 1.43,
  );

  final TextStyle _fieldTextStyle = TextStyle(
    decorationThickness: 0,
    color: Color(0xFF212529),
    fontSize: 15.sp,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w400,
    height: 1.3,
  );

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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _keywordController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _linkController.dispose();
    super.dispose();
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
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0.h),
                  child: TextFormField(
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 14.0.w, vertical: 12.0.h),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Color(0xffF5F6F7),
                        hintText: '콜렉션 선택',
                        hintStyle: _hintTextStyle),
                    style: _fieldTextStyle,
                    onFieldSubmitted: (String value) {},
                  ),
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
                  child: Container(
                    child: TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 14.0.w, vertical: 12.0.h),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Color(0xffF5F6F7),
                        hintText: '셀렉션 이름',
                        hintStyle: _hintTextStyle,
                      ),
                      style: _fieldTextStyle,
                      onFieldSubmitted: (String value) {},
                    ),
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
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Color(0xffADB5BD),
                        height: 1.43,
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
                        child: TextFormField(
                          controller: _keywordController,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 14.0.w, vertical: 12.0.h),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Color(0xffF5F6F7),
                              hintText: '키워드 추가',
                              hintStyle: _hintTextStyle),
                          style: _fieldTextStyle,
                          onFieldSubmitted: (String value) {
                            context.read<KeywordProvider>().addKeyword =
                                _keywordController.text;
                            _keywordController.clear();
                          },
                        ),
                      ),
                      SizedBox(
                        width: 16.0.w,
                      ),
                      AddButton(
                        onPressed: () {
                          context.read<KeywordProvider>().addKeyword =
                              _keywordController.text;
                          _keywordController.clear();
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0.h),
                  child: Consumer<KeywordProvider>(
                    builder: (context, provider, child) {
                      return Wrap(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.start,
                        spacing: 10.0.w,
                        runSpacing: 5.0.h,
                        children:
                            provider.keywordNames.asMap().entries.map((entry) {
                          int index = entry.key;
                          String keywords = entry.value;

                          return KeywordButton(
                            keywordName: keywords,
                            index: index,
                          );
                        }).toList(),
                      );
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
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    controller: _descriptionController,
                    textAlignVertical: TextAlignVertical.top,
                    textInputAction: TextInputAction.newline,
                    maxLines: null,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: 14.0.w,
                            right: 14.0.w,
                            top: 12.0.h,
                            bottom: 40.0.h),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Color(0xffF5F6F7),
                        hintText: '설명',
                        hintStyle: _hintTextStyle),
                    style: _fieldTextStyle,
                    onFieldSubmitted: (String value) {},
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
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Color(0xffADB5BD),
                        height: 1.43,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0.h),
                  child: TextFormField(
                    controller: _linkController,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 14.0.w, vertical: 12.0.h),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Color(0xffF5F6F7),
                        hintText: 'url 추가',
                        hintStyle: _hintTextStyle),
                    style: _fieldTextStyle,
                    onFieldSubmitted: (String value) {},
                  ),
                ),
                SizedBox(
                  height: 20.0.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _isOrder ? '순서' : '리스트',
                      style: TextStyle(
                        fontFamily: 'PretendardRegular',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff343A40),
                        height: 1.5,
                      ),
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
                  onPressed: () async {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
