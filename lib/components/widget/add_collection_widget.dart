import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/provider/tag_provider.dart';
import '../../data/services/api_service.dart';
import '../button/add_button.dart';
import '../button/complete_button.dart';
import '../button/tag_button.dart';
import '../pop_up/toast.dart';
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

  bool _isPublic = true;
  String _inputTagValue = '';

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
      final tagProvider = context.read<TagProvider>();
      tagProvider.clearTags();
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
      await ApiService.addCollection(_title!, _description,
          context.read<TagProvider>().tagNames, _isPublic);
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
    _tagFormKey.currentState?.save();
    context.read<TagProvider>().addTag = _inputTagValue;
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
                      keyboardType: TextInputType.text,
                      hintText: '컬렉션 이름',
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
                              keyboardType: TextInputType.text,
                              hintText: '태그 추가',
                              inputFormatter: [
                                FilteringTextInputFormatter.deny(RegExp(r'\s'))
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
                        inputFormatter: [LengthLimitingTextInputFormatter(100)],
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
                        _isPublic ? '전체 공개' : '비공개',
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
                          value: _isPublic,
                          onChanged: (value) {
                            setState(() {
                              _isPublic = value;
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
                    height: 20.0.h,
                  ),
                  CompleteButton(
                      firstFieldState: true,
                      secondFieldState: true,
                      text: '저장',
                      onTap: () {
                        FocusScope.of(context).unfocus();

                        WidgetsBinding.instance.addPostFrameCallback((_) async {
                          final fieldValidator = FieldValidator({
                            '컬렉션 이름을 입력해주세요': _title?.isNotEmpty == true,
                          });

                          if (!fieldValidator.validateFields()) {
                            return;
                          } else {
                            await _passFieldValidator();
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
