import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import '../../components/button/like_button.dart';
import '../../components/pop_up/edit_collection_dialog.dart';
import '../../components/pop_up/other_collection_dialog.dart';
import '../../components/ui_kit/category_tag.dart';
import '../../components/ui_kit/custom_app_bar.dart';
import '../../components/ui_kit/expandable_text.dart';
import '../../components/ui_kit/keyword.dart';
import '../../components/ui_kit/tag_text.dart';
import '../../components/ui_kit/text_utils.dart';
import '../../components/widget/selection_widget.dart';
import '../../data/model/collection_model.dart';
import '../../data/provider/collection_provider.dart';

class CollectionDetailScreen extends StatelessWidget {
  const CollectionDetailScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final String? _routeName = ModalRoute.of(context)?.settings.name;
    Future<void> _showDialog(CollectionModel _collectionDetail) async {
      final storage = FlutterSecureStorage();
      final userIdString = await storage.read(key: 'USER_ID');
      int userId = int.parse(userIdString!);
      showModalBottomSheet(
        context: context,
        isScrollControlled: false,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return userId == _collectionDetail.userId
              ? EditCollectionDialog(
                  routeName: _routeName!, collectionDetail: _collectionDetail)
              : OtherCollectionDialog(
                  routeName: _routeName!, collectionDetail: _collectionDetail);
        },
      );
    }

    return Consumer<CollectionProvider>(builder: (context, provider, child) {
      final CollectionModel _collectionDetail = provider.collectionDetail!;

      return Scaffold(
        backgroundColor: Color(0xFFf8f9fa),
        appBar: CustomAppbar(
          titleText: '컬렉션',
          actionButtonOnTap: () async {
            await _showDialog(_collectionDetail);
          },
          actionButton: 'icon_more',
        ),
        body: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                Color(0xFFf8f9fa),
              ],
              stops: [0.49, 0.51],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 26.0.h,
                      left: 16.0.w,
                      right: 16.0.w,
                      bottom: 36.0.h,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CategoryTag(
                          categoryId: _collectionDetail.categoryId,
                          buttonState: true,
                        ),
                        SizedBox(
                          height: 12.0.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                TextUtils.insertZwj(_collectionDetail.title),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22.sp,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w700,
                                  height: 1.4,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                            LikedButton(
                              collectionId: _collectionDetail.id,
                              isLiked: _collectionDetail.isLiked!,
                              likedNum: _collectionDetail.likeNum!,
                            ),
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
                              _collectionDetail.userName,
                              style: TextStyle(
                                color: Color(0xFFadb5bd),
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
                                color: Color(0xFFadb5bd),
                                height: 10.0.h,
                              ),
                            ),
                            Text(
                              _collectionDetail.createdAt!,
                              style: TextStyle(
                                color: Color(0xFFadb5bd),
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
                        _collectionDetail.description != null
                            ? ExpandableText(
                                maxLine: 1,
                                textStyle: TextStyle(
                                  color: Color(0xFF343a40),
                                  fontSize: 15.sp,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w500,
                                  height: 1.33,
                                ),
                                text: _collectionDetail.description!)
                            : SizedBox.shrink(),
                        _collectionDetail.tags != null
                            ? Padding(
                                padding: EdgeInsets.only(top: 24.0.h),
                                child: TagText(
                                  tags: _collectionDetail.tags!,
                                  maxLine: 3,
                                ),
                              )
                            : SizedBox.shrink(),
                        _collectionDetail.primaryKeywords != null
                            ? Padding(
                                padding: EdgeInsets.only(top: 22.0.h),
                                child: Wrap(
                                  direction: Axis.horizontal,
                                  alignment: WrapAlignment.start,
                                  spacing: 5.0.w,
                                  runSpacing: 5.0.h,
                                  children: _collectionDetail.primaryKeywords!
                                      .map((keyword) {
                                    return Keyword(
                                        keywordName: keyword.keywordName);
                                  }).toList(),
                                ),
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Color(0xFFf8f9fa),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 12.0.h),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'SELECTION',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16.sp,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      _collectionDetail.selectionNum != 0
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 18.0.w,
                              ),
                              child: SelectionWidget(
                                routeName: _routeName!,
                              ),
                            )
                          : Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 200.h),
                                child: Text(
                                  '셀렉션이 비어있습니다.',
                                  style: TextStyle(
                                    color: Color(0xFF868e96),
                                    fontSize: 14.sp,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
