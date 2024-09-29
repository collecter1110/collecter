import 'package:collect_er/components/pop_up/toast.dart';
import 'package:collect_er/data/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/model/collection_model.dart';
import '../button/cancel_button.dart';
import '../ui_kit/dialog_text.dart';

class EditCollectionDialog extends StatelessWidget {
  final CollectionModel collectionDetail;
  EditCollectionDialog({
    super.key,
    required this.collectionDetail,
  });

  @override
  Widget build(BuildContext context) {
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
                        print('삭제');
                        await ApiService.deleteCollection(collectionDetail.id);
                        Toast.completeToast('컬렉션이 삭제되었습니다');
                      },
                    ),
                    Divider(height: 0.5.h, color: Color(0xFFe9ecef)),
                    DialogText(
                      text: '컬렉션 수정',
                      textColor: Colors.black,
                      onTap: () {},
                    ),
                    Divider(height: 0.5.h, color: Color(0xFFe9ecef)),
                    DialogText(
                      text: '셀렉션 선택',
                      textColor: Colors.black,
                      onTap: () {},
                    ),
                    Divider(height: 0.5.h, color: Color(0xFFe9ecef)),
                    DialogText(
                      text: '셀렉션 추가',
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
