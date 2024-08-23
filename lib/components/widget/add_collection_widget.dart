import 'package:collect_er/components/button/add_button.dart';
import 'package:collect_er/data/provider/tag_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../button/complete_button.dart';
import '../button/tag_button.dart';

class AddCollectionWidget extends StatefulWidget {
  const AddCollectionWidget({super.key});

  @override
  State<AddCollectionWidget> createState() => _AddCollectionWidgetState();
}

class _AddCollectionWidgetState extends State<AddCollectionWidget> {
  TextEditingController _tagController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  bool _isPrivate = false;

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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _tagController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();

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
                        hintText: '컬렉션 이름',
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
                  '태그 추가',
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
                      'ex) 레시피, 영화, 읽은_책_모음',
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
                          controller: _tagController,
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
                              hintText: '태그 추가',
                              hintStyle: _hintTextStyle),
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(
                                RegExp(r'\s')), // 띄어쓰기를 필터링
                          ],
                          style: _fieldTextStyle,
                          onFieldSubmitted: (String value) {
                            context.read<TagProvider>().addTag = value;

                            _tagController.clear();
                          },
                        ),
                      ),
                      SizedBox(
                        width: 16.0.w,
                      ),
                      AddButton(
                        onPressed: () {
                          context.read<TagProvider>().addTag =
                              _tagController.text;
                          _tagController.clear();
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0.h),
                  child: Consumer<TagProvider>(
                    builder: (context, provider, child) {
                      return Wrap(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.start,
                        spacing: 10.0.w,
                        runSpacing: 5.0.h,
                        children:
                            provider.tagNames.asMap().entries.map((entry) {
                          int index = entry.key;
                          String keywords = entry.value;

                          return TagButton(
                            tagName: keywords,
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
                      _isPrivate ? '공개' : '비공개',
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
                      scale: 0.8, // 스위치의 크기 조절 (값을 변경하여 크기 조정)
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
