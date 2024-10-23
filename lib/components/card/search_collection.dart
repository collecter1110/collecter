import 'package:collect_er/data/model/collection_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/provider/collection_provider.dart';
import '../../data/services/data_service.dart';
import '../../data/services/storage_service.dart';
import '../../page/collection/collection_detail_screen.dart';
import '../ui_kit/keyword.dart';
import '../ui_kit/tag_text.dart';

class SearchCollection extends StatelessWidget {
  final CollectionModel collectionDetail;

  const SearchCollection({
    super.key,
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
            settings: RouteSettings(name: '/search'),
          ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100.0.w,
            child: AspectRatio(
              aspectRatio: 0.9,
              child: collectionDetail.imageFilePath != null
                  ? Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xFFdee2e6),
                          width: 0.5.w,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                        child: Image.network(
                          StorageService.getFullImageUrl(
                              '${collectionDetail.userId}/selections',
                              collectionDetail.imageFilePath!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                          color: Color(0xFFf1f3f5),
                          borderRadius: BorderRadius.circular(8)),
                    ),
            ),
          ),
          SizedBox(
            width: 16.0.w,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 2.0.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    collectionDetail.title,
                    style: TextStyle(
                      color: Color(0xFF343A40),
                      fontSize: 16.0.sp,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0.h),
                    child: collectionDetail.primaryKeywords != null
                        ? Wrap(
                            direction: Axis.horizontal,
                            alignment: WrapAlignment.start,
                            spacing: 5.0.w,
                            runSpacing: 8.0.h,
                            children: collectionDetail.primaryKeywords!
                                .map((keyword) {
                              return Keyword(keywordName: keyword.keywordName);
                            }).toList(),
                          )
                        : SizedBox.shrink(),
                  ),
                  Expanded(
                    child: collectionDetail.tags != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TagText(
                                tags: collectionDetail.tags!,
                                maxLine: 1,
                              ),
                            ],
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
