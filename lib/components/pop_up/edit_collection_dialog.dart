import 'package:collect_er/components/pop_up/toast.dart';
import 'package:collect_er/data/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/model/collection_model.dart';
import '../../data/provider/collection_provider.dart';
import '../../data/provider/user_info_provider.dart';
import '../../data/services/local_data.dart';
import '../../page/add_page/add_screen.dart';
import '../../page/collection/edit_collection_screen.dart';
import '../button/cancel_button.dart';
import '../ui_kit/dialog_text.dart';

class EditCollectionDialog extends StatelessWidget {
  final String routeName;
  final CollectionModel collectionDetail;

  EditCollectionDialog({
    super.key,
    required this.routeName,
    required this.collectionDetail,
  });

  @override
  Widget build(BuildContext context) {
    void closeDialog() {
      Navigator.pop(context);
    }

    Future<void> _updateLocalData() async {
      await LocalData.updateLocalData(
          context, collectionDetail.id, collectionDetail.userId, null);
    }

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0.w,
              ),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(12.0.r),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DialogText(
                      text: '컬렉션 삭제',
                      textColor: Colors.red,
                      onTap: () async {
                        bool? isDelete =
                            await Toast.deleteCollectionWarning(context);
                        if (isDelete!) {
                          await ApiService.deleteCollection(
                              collectionDetail.id);
                          Toast.completeToast('컬렉션이 삭제되었습니다');
                          await context
                              .read<UserInfoProvider>()
                              .fetchUserOverview();
                          await _updateLocalData();
                          closeDialog();
                          Navigator.pop(context);
                        }
                      },
                    ),
                    Divider(height: 0.5.h, color: Color(0xFFe9ecef)),
                    DialogText(
                      text: '컬렉션 수정',
                      textColor: Colors.black,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditCollectionScreen(
                                updateLocalData: () async {
                                  await context
                                      .read<CollectionProvider>()
                                      .fetchCollectionDetail();
                                  await _updateLocalData();
                                  closeDialog();
                                },
                                collectionDetail: collectionDetail),
                            settings: RouteSettings(name: routeName),
                          ),
                        );
                      },
                    ),
                    Divider(height: 0.5.h, color: Color(0xFFe9ecef)),
                    DialogText(
                      text: '셀렉션 추가',
                      textColor: Colors.black,
                      onTap: () async {
                        closeDialog();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddScreen(
                              initialTabIndex: 1,
                            ),
                            settings: RouteSettings(name: '/add'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 16.0.w, right: 16.0.w, top: 12.0.h, bottom: 20.0.h),
              child: CancelButton(),
            ),
          ],
        );
      },
    );
  }
}
