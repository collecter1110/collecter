import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/model/collection_model.dart';
import '../../data/provider/collection_provider.dart';
import '../button/complete_button.dart';
import '../button/set_collection_button.dart';
import '../constants/screen_size.dart';

class CollectionTitleDialog extends StatelessWidget {
  final Future<void> Function()? voidCallback;
  CollectionTitleDialog({
    super.key,
    this.voidCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CollectionProvider>(
      builder: (context, provider, child) {
        List<CollectionModel>? collections = provider.myCollections;
        int? selectedCollectionId = provider.collectionId;

        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0.r),
                topRight: Radius.circular(16.0.r),
              ),
              color: Colors.white,
            ),
            height: screenHeight(context) * 1 / 2,
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 24.0.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '컬렉션을 선택해주세요.',
                        style: TextStyle(
                          fontFamily: 'PretendardRegular',
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          height: 1.2,
                        ),
                      ),
                      InkWell(
                        child: SizedBox(
                          height: 16.0.h,
                          child: Image.asset(
                            'assets/icons/button_delete.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0.h),
                      child: ListView.separated(
                        primary: false,
                        scrollDirection: Axis.vertical,
                        itemCount: collections?.length ?? 0,
                        itemBuilder: (context, index) {
                          return SetCollectionButton(
                            title: collections![index].title,
                            collectionId: collections[index].id,
                            selectedCollectionId: selectedCollectionId,
                            onTap: (value) {
                              setState(() {
                                selectedCollectionId = value;
                                // print(selectedCollectionId);
                              });
                            },
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            height: 8.0.h,
                          );
                        },
                      ),
                    ),
                  ),
                  CompleteButton(
                    firstFieldState: true,
                    secondFieldState: selectedCollectionId != null,
                    onTap: () async {
                      provider.saveCollectionId = selectedCollectionId;
                      provider.saveCollectionTitle();
                      Navigator.pop(context);
                      print(selectedCollectionId);
                      await voidCallback?.call();
                    },
                    text: '선택',
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
