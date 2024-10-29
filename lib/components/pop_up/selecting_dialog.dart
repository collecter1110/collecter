import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/model/selecting_model.dart';
import '../../data/model/selection_model.dart';
import '../../data/provider/collection_provider.dart';
import '../../data/provider/selecting_provider.dart';
import '../../data/services/api_service.dart';
import '../../data/services/data_service.dart';
import '../../page/collection/collection_detail_screen.dart';
import '../button/cancel_button.dart';
import '../ui_kit/dialog_text.dart';
import 'collection_title_dialog.dart';
import 'report_dialog.dart';
import 'toast.dart';

class SelectingDialog extends StatelessWidget {
  final SelectionModel selectionDetail;
  SelectingDialog({super.key, required this.selectionDetail});

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
      final collectionProvider = context.read<CollectionProvider>();
      final selectingProvider = context.read<SelectingProvider>();
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
                  await ApiService.selecting(
                      collectionProvider.collectionId!, selectionDetail);
                  await selectingProvider.fetchSelectingData();
                  await collectionProvider.getCollectionDetailData();
                },
                () async {
                  _closeDialog();
                  await _didPush();
                  Toast.completeToast('나의 컬렉션에 셀렉팅되었습니다.');
                },
              );
            },
          );
        },
      );
    }

    Future<void> _showReportDialog() async {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return ReportDialog(
            reportType: 2,
            selectionProperties: PropertiesData.fromJson(
              {
                "collection_id": selectionDetail.collectionId,
                "selection_id": selectionDetail.selectionId,
              },
            ),
            voidCallback: () async {
              _closeDialog();
              Toast.notify('신고가 완료되었습니다.');
            },
          );
        },
      );
    }

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
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
                  children: [
                    DialogText(
                      text: '셀렉팅',
                      textColor: Colors.black,
                      onTap: () async {
                        (selectionDetail.isSelectable == false)
                            ? Toast.completeToast('셀렉팅이 제한된 셀렉션입니다.')
                            : await _showCollectionTitleDialog();
                      },
                    ),
                    Divider(height: 0.5.h, color: Color(0xFFe9ecef)),
                    DialogText(
                      text: '신고하기',
                      textColor: Colors.red,
                      onTap: () async {
                        await _showReportDialog();
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
