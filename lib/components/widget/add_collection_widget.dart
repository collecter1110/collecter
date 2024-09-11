import 'dart:io';

import 'package:collect_er/components/button/add_button.dart';
import 'package:collect_er/components/pop_up/toast.dart';
import 'package:collect_er/data/provider/tag_provider.dart';
import 'package:collect_er/data/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../data/provider/collection_provider.dart';
import '../button/complete_button.dart';
import '../button/tag_button.dart';
import '../text_field/add_text_form_field.dart';

class AddCollectionWidget extends StatefulWidget {
  const AddCollectionWidget({super.key});

  @override
  State<AddCollectionWidget> createState() => _AddCollectionWidgetState();
}

class _AddCollectionWidgetState extends State<AddCollectionWidget> {
  final GlobalKey<FormState> _tagFormKey = GlobalKey<FormState>();

  String? _title;
  String? _description;
  String? _imageFilePath;
  bool _isPrivate = false;
  String _inputTagValue = '';

  void _saveForm() {
    _tagFormKey.currentState?.save();
    context.read<TagProvider>().addTag = _inputTagValue;
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
    // context.read<TagProvider>().clearTags();
    super.dispose();
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
                      hintText: '컬렉션 이름',
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
                    '태그 추가 (선택)',
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
                      onTap: () async {
                        FocusScope.of(context).unfocus();

                        WidgetsBinding.instance.addPostFrameCallback((_) async {
                          print(_title);
                          print(_description);
                          print(context.read<TagProvider>().tagNames);
                          print(_isPrivate);
                          if (_title != null && _title != '') {
                            await ApiService.AddCollection(
                                _title!,
                                _description,
                                _imageFilePath,
                                context.read<TagProvider>().tagNames,
                                _isPrivate);

                            final collectionProvider =
                                context.read<CollectionProvider>();

                            await collectionProvider.fetchCollections();
                          } else {
                            Toast.missingFieldValue();
                          }
                        });
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
