import 'package:collect_er/data/model/selection_detail_model.dart';
import 'package:collect_er/data/provider/selection_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../components/button/link_button.dart';
import '../../components/ui_kit/custom_app_bar.dart';
import '../../components/ui_kit/expandable_text.dart';
import '../../components/ui_kit/keyword.dart';
import '../../components/widget/selection_item_widget.dart';

class SelectionDetailScreen extends StatelessWidget {
  const SelectionDetailScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectionDetailProvider>(
        builder: (context, provider, child) {
      final SelectionDetailModel? _selection = provider.selectionDetailModel;
      print(_selection);

      if (provider.fetchSelectionDetail == ConnectionState.waiting) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else {
        return Scaffold(
          appBar: CustomAppbar(
              popState: true,
              titleText: '셀렉션',
              titleState: true,
              actionButtonOnTap: () {},
              actionButton: null),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _selection!.imageFilePath != null
                    ? Container(
                        height: MediaQuery.of(context).size.width,
                        color: Colors.pink,
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
                            _selection.selectionName,
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
                          _selection.selectionLink != null
                              ? LinkButton(
                                  linkUrl: _selection.selectionLink!,
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
                            _selection.ownerName,
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
                            _selection.createdAt,
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
                        child: _selection.keywords != null
                            ? Wrap(
                                direction: Axis.horizontal,
                                alignment: WrapAlignment.start,
                                spacing: 5.0.w,
                                runSpacing: 8.0.h,
                                children: _selection.keywords!.map((keyword) {
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
                          text: _selection.selectionDescription ?? ''),
                    ],
                  ),
                ),
                SelectionItemWidget(
                  isOrder: _selection.isOrdered,
                  itemLength: _selection.items?.length ?? 0,
                ),
              ],
            ),
          ),
        );
      }
    });
  }
}
