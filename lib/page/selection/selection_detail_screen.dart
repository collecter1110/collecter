import 'package:collect_er/data/model/selection_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../components/button/link_button.dart';
import '../../components/ui_kit/custom_app_bar.dart';
import '../../components/ui_kit/expandable_text.dart';
import '../../components/ui_kit/keyword.dart';
import '../../components/widget/selection_item_widget.dart';
import '../../data/provider/selection_provider.dart';

class SelectionDetailScreen extends StatelessWidget {
  const SelectionDetailScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectionProvider>(builder: (context, provider, child) {
      final SelectionModel _selectionDetail = provider.selectionDetail!;

      return Scaffold(
        appBar: CustomAppbar(
          titleText: '셀렉션',
          actionButtonOnTap: () {},
          actionButton: 'icon_more',
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _selectionDetail.imageFilePaths != null
                  ? Container(
                      height: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: PageScrollPhysics(),
                          itemCount: _selectionDetail.imageFilePaths!.length,
                          itemBuilder: (context, index) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                      _selectionDetail.imageFilePaths![index]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          }),
                    )
                  : SizedBox.shrink(),
              Padding(
                padding: EdgeInsets.only(
                    left: 16.0.w, right: 16.0.w, top: 26.0.h, bottom: 42.0.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _selectionDetail.selectionName,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22.sp,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700,
                            height: 1.45,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        SizedBox(
                          width: 10.0.w,
                        ),
                        _selectionDetail.selectionLink != null
                            ? LinkButton(
                                linkUrl: _selectionDetail.selectionLink!,
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                    SizedBox(
                      height: 10.0.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _selectionDetail.ownerName,
                          style: TextStyle(
                            color: Color(0xFF868e96),
                            fontSize: 12.sp,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                            height: 1.5,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.0.w),
                          child: Image.asset(
                            'assets/images/image_vertical_line.png',
                            fit: BoxFit.contain,
                            color: Color(0xFF868e96),
                            height: 10.0.h,
                          ),
                        ),
                        Text(
                          _selectionDetail.createdAt!,
                          style: TextStyle(
                            color: Color(0xFF868e96),
                            fontSize: 12.sp,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 22.0.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.0.h),
                      child: _selectionDetail.keywords != null
                          ? Wrap(
                              direction: Axis.horizontal,
                              alignment: WrapAlignment.start,
                              spacing: 5.0.w,
                              runSpacing: 8.0.h,
                              children:
                                  _selectionDetail.keywords!.map((keyword) {
                                return Keyword(
                                    keywordName: keyword.keywordName);
                              }).toList(),
                            )
                          : SizedBox.shrink(),
                    ),
                    SizedBox(
                      height: 22.0.h,
                    ),
                    ExpandableText(
                        maxLine: 3,
                        textStyle: TextStyle(
                          color: Color(0xFF343a40),
                          fontSize: 14.sp,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                          height: 1.43,
                        ),
                        text: _selectionDetail.selectionDescription ?? ''),
                  ],
                ),
              ),
              SelectionItemWidget(
                isOrder: _selectionDetail.isOrdered!,
                itemLength: _selectionDetail.items?.length ?? 0,
              ),
            ],
          ),
        ),
      );
    });
  }
}
