import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/model/keyword_model.dart';
import '../../data/model/selecting_model.dart';
import '../../data/provider/selection_provider.dart';
import '../../data/services/storage_service.dart';
import '../../page/selection/selection_detail_screen.dart';
import '../ui_kit/keyword.dart';

class Selection extends StatelessWidget {
  final String? routeName;
  final String title;
  final String? thumbFilePath;
  final List<KeywordData>? keywords;
  final String ownerName;
  final int ownerId;
  final PropertiesData properties;

  const Selection({
    super.key,
    this.routeName,
    required this.title,
    this.thumbFilePath,
    this.keywords,
    required this.ownerName,
    required this.ownerId,
    required this.properties,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        context.read<SelectionProvider>().getSelectionProperties = properties;
        await context.read<SelectionProvider>().getSelectionDetailData();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SelectionDetailScreen(),
            settings: RouteSettings(name: routeName),
          ),
        );
      },
      child: AspectRatio(
        aspectRatio: 0.7,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 0.5,
                  blurRadius: 3,
                  offset: Offset(0, 0),
                )
              ],
              borderRadius: BorderRadius.circular(8.r)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              thumbFilePath != null
                  ? Expanded(
                      child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.r),
                            topRight: Radius.circular(8.r),
                          ),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  StorageService.getFullImageUrl(
                                      '$ownerId/selections', thumbFilePath!),
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )),
                    )
                  : SizedBox.shrink(),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 12.0.h),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
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
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.0.h),
                      child: keywords != null
                          ? SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: keywords!.map((keyword) {
                                  return Padding(
                                    padding: EdgeInsets.only(right: 5.0.w),
                                    child: Keyword(
                                        keywordName: keyword.keywordName),
                                  );
                                }).toList(),
                              ),
                            )
                          : SizedBox.shrink(),
                    ),
                    Text(
                      ownerName,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
