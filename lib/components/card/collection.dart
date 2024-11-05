import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/model/collection_model.dart';
import '../../data/provider/collection_provider.dart';
import '../../data/services/storage_service.dart';
import '../../page/collection/collection_detail_screen.dart';
import '../ui_kit/keyword.dart';

class Collection extends StatelessWidget {
  final String routName;
  final CollectionModel collectionDetail;

  const Collection({
    super.key,
    required this.routName,
    required this.collectionDetail,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        context.read<CollectionProvider>().saveCollectionId =
            collectionDetail.id;
        await context.read<CollectionProvider>().getCollectionDetailData();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CollectionDetailScreen(),
            settings: RouteSettings(name: routName),
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 0.9,
            child: collectionDetail.imageFilePath != null
                ? Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFFdee2e6),
                        width: 0.5.w,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.r),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.r),
                      ),
                      child: Image.network(
                        StorageService.getFullImageUrl(
                            '${collectionDetail.userId}/collections',
                            collectionDetail.imageFilePath!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                        color: Color(0xFFf1f3f5),
                        borderRadius: BorderRadius.circular(8.r)),
                  ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 2.0.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 12.0.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          collectionDetail.title,
                          style: TextStyle(
                            color: Color(0xFF343A40),
                            fontSize: 14.sp,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                            height: 1.43,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
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
                  Padding(
                    padding: EdgeInsets.only(top: 10.0.h),
                    child: collectionDetail.primaryKeywords != null
                        ? SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: collectionDetail.primaryKeywords!
                                  .map((keyword) {
                                return Padding(
                                  padding: EdgeInsets.only(right: 5.0.w),
                                  child:
                                      Keyword(keywordName: keyword.keywordName),
                                );
                              }).toList(),
                            ),
                          )
                        : SizedBox.shrink(),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
