import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/model/collection_model.dart';
import '../../data/provider/collection_provider.dart';
import '../../data/provider/selecting_provider.dart';
import '../../data/services/api_service.dart';
import '../../data/services/data_service.dart';
import '../../page/add_page/add_screen.dart';
import '../../page/collection/edit_collection_screen.dart';
import '../button/cancel_button.dart';
import '../ui_kit/dialog_text.dart';
import 'toast.dart';

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
    void _closeDialog() {
      Navigator.pop(context);
    }

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        final selectingProvider = context.read<SelectingProvider>();
        final collectionProvider = context.read<CollectionProvider>();
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
                        bool? isDelete = await Toast.showConfirmationDialog(
                            context, '컬렉션과 관련된 셀렉션도 함께 삭제됩니다.\n삭제하시겠습니까?');

                        if (isDelete == null) {
                          return;
                        }
                        if (isDelete) {
                          await DataService.updateDataProcessHandler(
                            context,
                            () async {
                              await ApiService.deleteCollection(
                                  collectionDetail);
                              if (collectionDetail.selectionNum != 0) {
                                await selectingProvider.fetchSelectingData();
                                await selectingProvider.fetchSelectedData();
                              }
                            },
                            () async {
                              _closeDialog();
                              Navigator.pop(context);
                              Toast.completeToast('컬렉션이 삭제되었습니다');
                            },
                          );
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
                                callback: () async {
                                  await DataService.updateDataProcessHandler(
                                    context,
                                    () async {
                                      await collectionProvider
                                          .fetchCollectionDetail();
                                    },
                                    () async {
                                      _closeDialog();
                                      Toast.completeToast('컬렉션이 수정되었습니다.');
                                    },
                                  );
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
                        _closeDialog();
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
