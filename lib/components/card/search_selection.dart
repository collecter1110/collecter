import 'package:collecter/components/widget/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/model/selecting_model.dart';
import '../../data/model/selection_model.dart';
import '../../data/provider/selection_provider.dart';
import '../../data/services/api_service.dart';
import '../../page/selection/selection_detail_screen.dart';
import '../button/go_collection_button.dart';
import '../ui_kit/keyword.dart';
import '../ui_kit/text_utils.dart';

class SearchSelection extends StatelessWidget {
  final SelectionModel selectionDetail;
  final PropertiesData properties;

  SearchSelection({
    super.key,
    required this.selectionDetail,
    required this.properties,
  });
  String? collectionTitle;

  Future<String> fetchCollectionTitle() async {
    collectionTitle =
        await ApiService.getCollectionTitle(selectionDetail.collectionId!);
    return collectionTitle!;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: fetchCollectionTitle(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return GestureDetector(
              onTap: () async {
                context.read<SelectionProvider>().getSelectionProperties =
                    properties;
                await context
                    .read<SelectionProvider>()
                    .getSelectionDetailData();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectionDetailScreen(),
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
                      child: selectionDetail.thumbFilePath != null
                          ? ImageWidget(
                              storageFolderName:
                                  '${selectionDetail.ownerId}/selections',
                              imageFilePath: selectionDetail.thumbFilePath!,
                              borderRadius: 8.r,
                            )
                          : Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Color(0xFFf1f3f5),
                                  borderRadius: BorderRadius.circular(8.r)),
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
                          GoCollectionButton(
                            collectionId: selectionDetail.collectionId!,
                            collectionName: collectionTitle ?? '',
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0.h),
                            child: Text(
                              TextUtils.insertZwj(selectionDetail.title),
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
                          ),
                          selectionDetail.keywords != null
                              ? Wrap(
                                  direction: Axis.horizontal,
                                  alignment: WrapAlignment.start,
                                  spacing: 5.0.w,
                                  runSpacing: 8.0.h,
                                  children:
                                      selectionDetail.keywords!.map((keyword) {
                                    return Keyword(
                                        keywordName: keyword.keywordName);
                                  }).toList(),
                                )
                              : SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }
}
