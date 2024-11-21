import 'package:collecter/components/widget/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../data/model/collection_model.dart';
import '../../data/provider/collection_provider.dart';
import '../../page/collection/collection_detail_screen.dart';
import '../ui_kit/text_utils.dart';

class Collection extends StatelessWidget {
  final String routName;
  final CollectionModel collectionDetail;
  final bool isRanking;

  const Collection({
    super.key,
    required this.routName,
    required this.collectionDetail,
    required this.isRanking,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        context.read<CollectionProvider>().saveCollectionId =
            collectionDetail.id;
        await context.read<CollectionProvider>().fetchCollectionDetail();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CollectionDetailScreen(),
            settings: RouteSettings(name: routName),
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 0.9,
                child: collectionDetail.imageFilePath != null
                    ? ImageWidget(
                        storageFolderName:
                            '${collectionDetail.userId}/collections',
                        imageFilePath: collectionDetail.imageFilePath!,
                        boarderRadius: 8.r,
                      )
                    : Container(
                        decoration: BoxDecoration(
                            color: Color(0xFFf1f3f5),
                            borderRadius: BorderRadius.circular(8.r)),
                      ),
              ),
              collectionDetail.isPublic
                  ? SizedBox.shrink()
                  : Positioned(
                      top: 6.0.w,
                      right: 4.0.w,
                      child: SvgPicture.asset(
                        'assets/icons/icon_lock.svg',
                        height: 24.0.h,
                        colorFilter:
                            ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      ),
                    ),
            ],
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 2.0.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Container(
                        height: 40.04.sp,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.only(right: 20.0.w),
                            child: Text(
                              TextUtils.insertZwj(collectionDetail.title),
                              style: TextStyle(
                                color: Color(0xFF343A40),
                                fontSize: 14.sp,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w600,
                                height: 1.43,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0.w, right: 4.0.w),
                      child: Text(
                        '${collectionDetail.selectionNum}',
                        style: TextStyle(
                          color: Color(0xFFadb5bd),
                          fontSize: 14.sp,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w400,
                          height: 1.43,
                        ),
                      ),
                    ),
                  ],
                ),
                isRanking
                    ? Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/icon_user.svg',
                            colorFilter: ColorFilter.mode(
                                Color(0xFFadb5bd), BlendMode.srcIn),
                            height: 10.0.h,
                          ),
                          SizedBox(
                            width: 4.0.w,
                          ),
                          Text(
                            '${collectionDetail.userName}',
                            style: TextStyle(
                              color: Color(0xFF868E96),
                              fontSize: 10.sp,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      )
                    : SizedBox.shrink()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
