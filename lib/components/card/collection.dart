import 'package:collect_er/data/model/collection_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/provider/collection_provider.dart';
import '../../page/collection/collection_detail_screen.dart';
import '../ui_kit/keyword.dart';

class Collection extends StatelessWidget {
  final CollectionModel collectionDetail;

  const Collection({
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
            settings: RouteSettings(name: '/bookmark'),
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1 / 1,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Color(0xFFf1f3f5),
                  borderRadius: BorderRadius.circular(8)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  collectionDetail.imageFilePath != null
                      ? Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(6),
                            ),
                            child: Container(
                              width: double.infinity,
                              child: Image.asset(
                                'assets/images/IMG_4498.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                ],
              ),
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
                    height: 6.0.h,
                  ),
                  Text(
                    collectionDetail.title,
                    style: TextStyle(
                      color: Color(0xFF343A40),
                      fontSize: 15.sp,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                      height: 1.33,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    '${collectionDetail.selectionNum}',
                    style: TextStyle(
                      color: Color(0xFF868e96),
                      fontSize: 14.sp,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                      height: 1.43,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0.h),
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
