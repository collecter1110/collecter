import 'package:collect_er/components/pop_up/collection_title_dialog.dart';
import 'package:collect_er/components/pop_up/toast.dart';
import 'package:collect_er/data/model/selection_model.dart';
import 'package:collect_er/data/provider/selecting_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/provider/collection_provider.dart';
import '../../data/provider/selection_provider.dart';
import '../../data/services/api_service.dart';
import '../../data/services/data_service.dart';
import '../../page/collection/collection_detail_screen.dart';
import '../../page/selection/edit_selection_screen.dart';
import '../button/cancel_button.dart';
import '../ui_kit/dialog_text.dart';

class EditSelectionDialog extends StatelessWidget {
  final String routeName;
  final SelectionModel selectionDetail;

  EditSelectionDialog({
    super.key,
    required this.routeName,
    required this.selectionDetail,
  });

  @override
  Widget build(BuildContext context) {
    Future<void> _didPush() async {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/bookmark',
          (Route<dynamic> route) => false,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CollectionDetailScreen(),
            settings: RouteSettings(name: '/bookmark'),
          ),
        );
      });
    }

    void _closeDialog() {
      Navigator.pop(context);
    }

    Future<void> _saveCollectionTitle() async {
      final provider = context.read<CollectionProvider>();
      provider.saveCollectionId = selectionDetail.collectionId;
    }

    Future<void> _showCollectionTitleDialog() async {
      final provider = context.read<CollectionProvider>();
      await _saveCollectionTitle();
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return CollectionTitleDialog(
            voidCallback: () async {
              await DataService.updateDataProcessHandler(
                context,
                selectionDetail.collectionId,
                selectionDetail.userId!,
                selectionDetail.selectionId,
                () async {
                  await ApiService.moveSelection(selectionDetail.collectionId,
                      selectionDetail.selectionId, provider.collectionId!);
                  await provider.getCollectionDetailData();
                },
                () async {
                  _closeDialog();
                  await _didPush();
                  Toast.completeToast('셀렉션이 이동되었습니다');
                },
              );
            },
          );
        },
      );
    }

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        final collectionProvider = context.read<CollectionProvider>();
        final selectionProvider = context.read<SelectionProvider>();
        final selectingProvider = context.read<SelectingProvider>();
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
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
                      text: '셀렉션 삭제',
                      textColor: Colors.red,
                      onTap: () async {
                        bool? isDelete =
                            await Toast.deleteSelectionWarning(context);

                        if (isDelete == true) {
                          await DataService.updateDataProcessHandler(
                            context,
                            selectionDetail.collectionId,
                            selectionDetail.userId!,
                            selectionDetail.selectionId,
                            () async {
                              await ApiService.deleteSelection(selectionDetail);

                              if (selectionDetail.isSelecting == true) {
                                await selectingProvider.fetchSelectingData();
                              } else if (selectionDetail.isSelecting == false) {
                                await selectingProvider.fetchSelectedData();
                              }
                              if (routeName != '/user') {
                                await collectionProvider
                                    .fetchCollectionDetail();
                                await selectionProvider.fetchSelectionData();
                              }
                            },
                            () async {
                              _closeDialog();
                              Navigator.pop(context);
                              Toast.completeToast('셀렉션이 삭제되었습니다');
                            },
                          );
                        }
                      },
                    ),
                    Divider(height: 0.5.h, color: Color(0xFFe9ecef)),
                    DialogText(
                      text: '셀렉션 수정',
                      textColor: Colors.black,
                      onTap: () async {
                        if (selectionDetail.isSelecting == true) {
                          Toast.notify('셀렉팅한 셀렉션은 수정할 수 없습니다.');
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditSelectionScreen(
                                  callback: () async {
                                    await DataService.updateDataProcessHandler(
                                      context,
                                      selectionDetail.collectionId,
                                      selectionDetail.userId!,
                                      selectionDetail.selectionId,
                                      () async {
                                        await collectionProvider
                                            .fetchCollectionDetail();
                                        await selectionProvider
                                            .fetchSelectionData();
                                        await selectionProvider
                                            .getSelectionDetailData();
                                      },
                                      () async {
                                        _closeDialog();
                                        Toast.completeToast('셀렉션이 수정되었습니다');
                                      },
                                    );
                                  },
                                  selectionDetail: selectionDetail),
                              settings: RouteSettings(name: routeName),
                            ),
                          );
                        }
                      },
                    ),
                    Divider(height: 0.5.h, color: Color(0xFFe9ecef)),
                    DialogText(
                      text: '컬렉션 이동',
                      textColor: Colors.black,
                      onTap: () async {
                        await _showCollectionTitleDialog();
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
