import 'package:collecter/components/widget/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../data/model/keyword_model.dart';
import '../../data/model/selecting_model.dart';
import '../../data/provider/selection_provider.dart';
import '../../page/selection/selection_detail_screen.dart';
import '../ui_kit/keyword.dart';
import '../ui_kit/text_utils.dart';

class Selection extends StatelessWidget {
  final String? routeName;
  final String title;
  final String? thumbFilePath;
  final List<KeywordData>? keywords;
  final String ownerName;
  final int ownerId;
  final PropertiesData properties;
  final bool isRanking;

  const Selection({
    super.key,
    this.routeName,
    required this.title,
    this.thumbFilePath,
    this.keywords,
    required this.ownerName,
    required this.ownerId,
    required this.properties,
    required this.isRanking,
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
        aspectRatio: 0.67,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFe9ecef),
                  spreadRadius: 5,
                  blurRadius: 5,
                  offset: Offset(0, 0),
                )
              ],
              borderRadius: BorderRadius.circular(8.r)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.r),
                    topRight: Radius.circular(8.r),
                  ),
                  child: thumbFilePath != null
                      ? ImageWidget(
                          storageFolderName: '${ownerId}/selections',
                          imageFilePath: thumbFilePath!,
                          boarderRadius: 0.r,
                        )
                      : SizedBox.shrink(),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 10.0.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: isRanking ? 19.95.sp : 39.9.sp,
                      child: Text(
                        TextUtils.insertZwj(title),
                        style: TextStyle(
                          color: Color(0xFF343A40),
                          fontSize: 15.sp,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600,
                          height: 1.33,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: isRanking ? 1 : 2,
                      ),
                    ),
                    keywords != null && isRanking
                        ? SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                              padding: EdgeInsets.only(top: 3.0.h),
                              child: Row(
                                children: keywords!.map((keyword) {
                                  return Padding(
                                    padding: EdgeInsets.only(right: 5.0.w),
                                    child: Keyword(
                                        keywordName: keyword.keywordName),
                                  );
                                }).toList(),
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.0.w,
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/icon_user.svg',
                      colorFilter:
                          ColorFilter.mode(Color(0xFFadb5bd), BlendMode.srcIn),
                      height: 10.0.h,
                    ),
                    SizedBox(
                      width: 4.0.w,
                    ),
                    Text(
                      '${ownerName}',
                      style: TextStyle(
                        color: Color(0xFF868E96),
                        fontSize: 10.sp,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
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
