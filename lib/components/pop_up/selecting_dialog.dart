import 'package:collect_er/components/pop_up/collection_title_dialog.dart';
import 'package:collect_er/components/pop_up/toast.dart';
import 'package:collect_er/data/model/selection_model.dart';
import 'package:collect_er/data/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/provider/collection_provider.dart';
import '../../data/services/data_management.dart';
import '../../page/collection/collection_detail_screen.dart';
import '../button/cancel_button.dart';
import '../ui_kit/dialog_text.dart';

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

    Future<void> _getCollectionTitle() async {
      final provider = context.read<CollectionProvider>();
      if (provider.myCollections == null) {
        await provider.fetchCollections();
      }
      provider.saveCollectionId = selectionDetail.collectionId;
    }

    Future<void> _showGroupDialog() async {
      final provider = context.read<CollectionProvider>();
      await _getCollectionTitle();
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return CollectionTitleDialog(
            voidCallback: () async {
              await DataManagement.updateDataProcessHandler(
                context,
                selectionDetail.collectionId,
                selectionDetail.userId!,
                selectionDetail.selectionId,
                () async {
                  await ApiService.selecting(
                      provider.collectionId!, selectionDetail);
                  await provider.getCollectionDetailData();
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
                child: DialogText(
                  text: '셀렉팅',
                  textColor: Colors.black,
                  onTap: () async {
                    await _showGroupDialog();
                  },
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
