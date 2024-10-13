import 'package:collect_er/components/pop_up/selecting_dialog.dart';
import 'package:collect_er/data/model/selection_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../components/button/link_button.dart';
import '../../components/pop_up/edit_selection_dialog.dart';
import '../../components/ui_kit/custom_app_bar.dart';
import '../../components/ui_kit/expandable_text.dart';
import '../../components/ui_kit/keyword.dart';
import '../../components/widget/selection_item_widget.dart';
import '../../data/provider/selection_provider.dart';

class SelectionDetailScreen extends StatefulWidget {
  const SelectionDetailScreen({
    super.key,
  });

  @override
  State<SelectionDetailScreen> createState() => _SelectionDetailScreenState();
}

class _SelectionDetailScreenState extends State<SelectionDetailScreen> {
  final PageController _pageController = PageController();

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String? _routeName = ModalRoute.of(context)?.settings.name;
    return Consumer<SelectionProvider>(builder: (context, provider, child) {
      final SelectionModel _selectionDetail = provider.selectionDetail!;
      final int imageNum = _selectionDetail.imageFilePaths?.length ?? 0;

      Future<void> _showDialog() async {
        final storage = FlutterSecureStorage();
        final userIdString = await storage.read(key: 'USER_ID');

        int userId = int.parse(userIdString!);

        showModalBottomSheet(
          context: context,
          isScrollControlled: false,
          backgroundColor: Colors.transparent,
          builder: (context) {
            return userId == _selectionDetail.userId
                ? EditSelectionDialog(
                    isOwner: userId == _selectionDetail.ownerId,
                    routeName: _routeName!,
                    selectionDetail: _selectionDetail,
                  )
                : SelectingDialog(
                    selectionDetail: _selectionDetail,
                  );
          },
        );
      }

      return Scaffold(
        backgroundColor:
            _selectionDetail.items == null ? Colors.white : Color(0xFFf8f9fa),
        appBar: CustomAppbar(
          titleText: '셀렉션',
          actionButtonOnTap: () async {
            await _showDialog();
          },
          actionButton: 'icon_more',
        ),
        body: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                Color(0xFFf8f9fa),
              ],
              stops: [0.49, 0.51],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _selectionDetail.imageFilePaths != null
                    ? Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            AspectRatio(
                              aspectRatio: 1 / 1,
                              child: PageView.builder(
                                  controller: _pageController,
                                  onPageChanged: (index) {
                                    setState(() {
                                      _currentPage = index;
                                    });
                                  },
                                  scrollDirection: Axis.horizontal,
                                  physics: PageScrollPhysics(),
                                  itemCount:
                                      _selectionDetail.imageFilePaths!.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 16.0.h,
                                        horizontal: 16.0.w,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  _selectionDetail
                                                      .imageFilePaths![index]),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                imageNum,
                                (index) => Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 2.0.w),
                                  child: Container(
                                    width: 7.0.h,
                                    height: 7.0.h,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _currentPage == index
                                          ? Color(0xFF212529)
                                          : Color(0xFFdee2e6),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox.shrink(),
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 16.0.w,
                        right: 16.0.w,
                        top: 26.0.h,
                        bottom: 22.0.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _selectionDetail.title,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22.sp,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w700,
                                height: 1.45,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            _selectionDetail.link != null
                                ? LinkButton(
                                    linkUrl: _selectionDetail.link!,
                                  )
                                : SizedBox.shrink(),
                          ],
                        ),
                        SizedBox(
                          height: 10.0.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _selectionDetail.ownerName,
                              style: TextStyle(
                                color: Color(0xFFadb5bd),
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
                                color: Color(0xFFadb5bd),
                                height: 10.0.h,
                              ),
                            ),
                            Text(
                              _selectionDetail.createdAt!,
                              style: TextStyle(
                                color: Color(0xFFadb5bd),
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
                        _selectionDetail.description != null
                            ? Padding(
                                padding: EdgeInsets.only(bottom: 22.0.h),
                                child: ExpandableText(
                                    maxLine: 3,
                                    textStyle: TextStyle(
                                      color: Color(0xFF343a40),
                                      fontSize: 14.sp,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w500,
                                      height: 1.43,
                                    ),
                                    text: _selectionDetail.description!),
                              )
                            : SizedBox.shrink(),
                        _selectionDetail.keywords != null
                            ? Wrap(
                                direction: Axis.horizontal,
                                alignment: WrapAlignment.start,
                                spacing: 5.0.w,
                                runSpacing: 8.0.h,
                                children:
                                    _selectionDetail.keywords!.map((keyword) {
                                  return Keyword(
                                      keywordName: keyword.keywordName);
                                }).toList(),
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                  ),
                ),
                _selectionDetail.items != null
                    ? SelectionItemWidget(
                        isOrder: _selectionDetail.isOrdered!,
                        itemLength: _selectionDetail.items!.length,
                      )
                    : SizedBox.shrink()
              ],
            ),
          ),
        ),
      );
    });
  }
}
