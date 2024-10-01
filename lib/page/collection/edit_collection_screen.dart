import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../components/button/add_button.dart';
import '../../components/button/complete_button.dart';
import '../../components/button/tag_button.dart';
import '../../components/text_field/add_text_form_field.dart';
import '../../components/ui_kit/custom_app_bar.dart';
import '../../data/model/collection_model.dart';
import '../../data/provider/tag_provider.dart';

class EditCollectionScreen extends StatefulWidget {
  final CollectionModel collectionDetail;
  const EditCollectionScreen({
    super.key,
    required this.collectionDetail,
  });

  @override
  State<EditCollectionScreen> createState() => _EditCollectionScreenState();
}

class _EditCollectionScreenState extends State<EditCollectionScreen> {
  final GlobalKey<FormState> _tagFormKey = GlobalKey<FormState>();
  String? _title;
  String _inputTagValue = '';
  String? _description;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _saveForm() {
    _tagFormKey.currentState?.save();
    context.read<TagProvider>().addTag = _inputTagValue;
  }

  Future<void> initializeData() async {
    final tagProvider = context.read<TagProvider>();

    if (widget.collectionDetail.tags != null) {
      tagProvider.saveTags = widget.collectionDetail.tags!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        titleText: '수정',
        actionButtonOnTap: () async {},
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
                          Container(
                            width: 100.w,
                            child: widget.collectionDetail.imageFilePath != null
                                ? AspectRatio(
                                    aspectRatio: 1 / 1,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(widget
                                                .collectionDetail
                                                .imageFilePath!),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      print('ㅇㅇ');
                                    },
                                    child: AspectRatio(
                                      aspectRatio: 1 / 1,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                        child: Container(
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
                                        ),
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
                                  fontSize: 15.sp,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w500,
                                  height: 1.33,
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
                          _title = value;
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
                            _description = value ?? '';
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 26.0.h,
                    ),
                    CompleteButton(
                      firstFieldState: true,
                      secondFieldState: true,
                      onTap: () async {},
                      text: '수정 완료',
                    ),
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
