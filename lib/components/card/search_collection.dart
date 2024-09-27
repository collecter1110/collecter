import 'package:collect_er/data/model/collection_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/provider/collection_provider.dart';
import '../../page/collection/collection_detail_screen.dart';
import '../ui_kit/keyword.dart';
import '../ui_kit/tag_text_style.dart';

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
        context.read<CollectionProvider>().getCollectionId =
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AspectRatio(
            aspectRatio: 0.9,
            child: collectionDetail.imageFilePath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(collectionDetail.imageFilePath!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                        color: Color(0xFFf1f3f5),
                        borderRadius: BorderRadius.circular(8)),
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
                    maxLines: 1,
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
                              TagTextStyle(
                                tags: collectionDetail.tags!,
                                color: Color(0xFF868E96),
                                maxLine: 2,
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
