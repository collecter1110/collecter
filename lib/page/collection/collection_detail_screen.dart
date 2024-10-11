import 'package:collect_er/components/button/like_button.dart';
import 'package:collect_er/components/pop_up/user_info_dialog.dart';
import 'package:collect_er/components/widget/selection_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import '../../components/pop_up/edit_collection_dialog.dart';
import '../../components/ui_kit/custom_app_bar.dart';
import '../../components/ui_kit/expandable_text.dart';
import '../../components/ui_kit/keyword.dart';
import '../../components/ui_kit/tag_text_style.dart';
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
              : UserInfoDialog(collectionDetail: _collectionDetail);
        },
      );
    }

    return Consumer<CollectionProvider>(builder: (context, provider, child) {
      final CollectionModel _collectionDetail = provider.collectionDetail!;

      return Scaffold(
        appBar: CustomAppbar(
          titleText: '컬렉션',
          actionButtonOnTap: () async {
            await _showDialog(_collectionDetail);
          },
          actionButton: 'icon_more',
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: 16.0.w, right: 16.0.w, bottom: 46.0.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _collectionDetail.imageFilePath != null
                        ? Padding(
                            padding: EdgeInsets.only(top: 16.0.h),
                            child: AspectRatio(
                              aspectRatio: 1 / 1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                child: Container(
                                  height: 300.h,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          _collectionDetail.imageFilePath!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 26.0.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _collectionDetail.title,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 22.sp,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w700,
                              height: 1.4,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          likedButton(
                            collectionId: _collectionDetail.id,
                            isLiked: _collectionDetail.isLiked!,
                            likedNum: _collectionDetail.likeNum!,
                          ),
                        ],
                      ),
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
                          _collectionDetail.createdAt!,
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
                    ExpandableText(
                        maxLine: 3,
                        textStyle: TextStyle(
                          color: Color(0xFF343a40),
                          fontSize: 14.sp,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                          height: 1.43,
                        ),
                        text: _collectionDetail.description ?? ''),
                    SizedBox(
                      height: 32.0.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.0.h),
                      child: _collectionDetail.tags != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TagTextStyle(
                                  tags: _collectionDetail.tags!,
                                  color: Color(0xFF868E96),
                                  maxLine: 3,
                                ),
                              ],
                            )
                          : SizedBox.shrink(),
                    ),
                    SizedBox(
                      height: 22.0.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.0.h),
                      child: _collectionDetail.primaryKeywords != null
                          ? Wrap(
                              direction: Axis.horizontal,
                              alignment: WrapAlignment.start,
                              spacing: 5.0.w,
                              runSpacing: 5.0.h,
                              children: _collectionDetail.primaryKeywords!
                                  .map((keyword) {
                                return Keyword(
                                    keywordName: keyword.keywordName);
                              }).toList(),
                            )
                          : SizedBox.shrink(),
                    ),
                  ],
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
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 18.0.w,
                        vertical: 20.0.h,
                      ),
                      child: SelectionWidget(
                          routeName: _routeName!,
                          collectionId: _collectionDetail.id),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
