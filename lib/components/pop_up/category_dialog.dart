import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../page/user_page/setting/contact_screen.dart';
import '../button/complete_button.dart';
import '../button/set_collection_button.dart';
import '../constants/screen_size.dart';

class CategoryDialog extends StatelessWidget {
  final ValueChanged<int> saveCategory;
  CategoryDialog({
    super.key,
    required this.saveCategory,
  });

  @override
  Widget build(BuildContext context) {
    List<String> category = [
      '🎸 음악',
      '📚 책',
      '🎬 영화/TV',
      '🥘 요리',
      '🚩 장소',
      '🥃 테이스팅 노트',
      '😎 기타',
      '➡️ 카테고리 제안하기'
    ];
    int? selectedCategoryId = null;

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
          padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 24.0.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '카테고리를 선택해주세요.',
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
                    itemCount: category.length,
                    itemBuilder: (context, index) {
                      return SetCollectionButton(
                        title: category[index],
                        collectionId: index,
                        selectedCollectionId: selectedCategoryId,
                        onTap: (value) {
                          setState(() {
                            selectedCategoryId = value;
                            if (selectedCategoryId == category.length - 1) {
                              print(selectedCategoryId);
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ContactScreen(),
                                  settings: RouteSettings(name: '/user'),
                                ),
                              );
                            }
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
                secondFieldState: selectedCategoryId != null,
                onTap: () async {
                  Navigator.pop(context);
                  print(selectedCategoryId);
                  saveCategory(selectedCategoryId!);
                },
                text: '선택',
              ),
            ],
          ),
        ),
      );
    });
  }
}
