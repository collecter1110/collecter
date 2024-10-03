import 'package:collect_er/components/pop_up/toast.dart';
import 'package:collect_er/data/model/selection_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/provider/collection_provider.dart';
import '../../data/provider/selection_provider.dart';
import '../../data/services/api_service.dart';
import '../../data/services/local_data.dart';
import '../button/cancel_button.dart';
import '../ui_kit/dialog_text.dart';

class EditSelectionDialog extends StatelessWidget {
  final String routeName;
  final SelectionModel selectionDetail;
  final VoidCallback didPop;
  EditSelectionDialog({
    super.key,
    required this.routeName,
    required this.selectionDetail,
    required this.didPop,
  });

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        Future<void> _updateLocalData() async {
          Navigator.pop(context);
          await LocalData.updateLocalData(
            context,
            selectionDetail.collectionId,
            selectionDetail.userId!,
            selectionDetail.selectionId,
          );
          didPop();
        }

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
                        if (isDelete!) {
                          await ApiService.deleteSelection(
                              selectionDetail.collectionId,
                              selectionDetail.selectionId);
                          Toast.completeToast('셀렉션이 삭제되었습니다');
                          // await context
                          //     .read<UserInfoProvider>()
                          //     .fetchUserOverview();
                          final collectionProvider =
                              context.read<CollectionProvider>();
                          final selectionProvider =
                              context.read<SelectionProvider>();
                          await collectionProvider.fetchCollectionDetail();
                          await selectionProvider.fetchSelectionData();
                          await _updateLocalData();
                        }
                      },
                    ),
                    Divider(height: 0.5.h, color: Color(0xFFe9ecef)),
                    DialogText(
                      text: '셀렉션 수정',
                      textColor: Colors.black,
                      onTap: () {},
                    ),
                    Divider(height: 0.5.h, color: Color(0xFFe9ecef)),
                    DialogText(
                      text: '컬렉션 이동',
                      textColor: Colors.black,
                      onTap: () {},
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
