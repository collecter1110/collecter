import 'package:collect_er/data/model/keyword_model.dart';
import 'package:collect_er/data/model/selecting_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/provider/selection_provider.dart';
import '../../page/selection/selection_detail_screen.dart';
import '../ui_kit/keyword.dart';

class Selection extends StatelessWidget {
  final String routeName;
  final String title;
  final String? imageFilePath;
  final List<KeywordData>? keywords;
  final String ownerName;
  final PropertiesData properties;

  const Selection({
    super.key,
    required this.routeName,
    required this.title,
    this.imageFilePath,
    this.keywords,
    required this.ownerName,
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
              borderRadius: BorderRadius.circular(8)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              imageFilePath != null
                  ? Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
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
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 16.0.h),
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
                      maxLines: 2,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.0.h),
                      child: keywords != null
                          ? Wrap(
                              direction: Axis.horizontal,
                              alignment: WrapAlignment.start,
                              spacing: 5.0.w,
                              runSpacing: 8.0.h,
                              children: keywords!.map((keyword) {
                                return Keyword(
                                    keywordName: keyword.keywordName);
                              }).toList(),
                            )
                          : SizedBox.shrink(),
                    ),
                    SizedBox(
                      height: 4.0.h,
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
