import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/model/category_model.dart';
import '../../data/provider/category_provider.dart';
import '../../page/user_page/setting/contact_screen.dart';
import '../button/complete_button.dart';
import '../button/set_collection_button.dart';
import '../constants/screen_size.dart';

class CategoryDialog extends StatelessWidget {
  final ValueChanged<CategoryModel> saveCategory;
  int? selectedCategoryId;
  CategoryDialog({
    super.key,
    required this.saveCategory,
    this.selectedCategoryId,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(builder: (context, provider, child) {
      final List<CategoryModel> _categoryInfo = provider.categoryInfo;

      if (_categoryInfo.isNotEmpty) {
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                          SizedBox(
                            height: 10.0.h,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ContactScreen(),
                                  settings: RouteSettings(name: '/user'),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/icons/icon_send.png',
                                  color: Color(0xFFced4da),
                                  height: 8.0.h,
                                ),
                                SizedBox(
                                  width: 4.0.w,
                                ),
                                Text(
                                  '카테고리 제안하기',
                                  style: TextStyle(
                                    fontFamily: 'PretendardRegular',
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFced4da),
                                    height: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
                        itemCount: _categoryInfo.length,
                        itemBuilder: (context, index) {
                          return SetCollectionButton(
                            title: _categoryInfo[index].categoryName,
                            collectionId: _categoryInfo[index].categoryId,
                            selectedCollectionId: selectedCategoryId,
                            onTap: (value) {
                              setState(() {
                                print('선택한 카테고리 아이디 :$value');
                                selectedCategoryId = value;
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
                      saveCategory(_categoryInfo.firstWhere((category) =>
                          category.categoryId == selectedCategoryId));
                    },
                    text: '선택',
                  ),
                ],
              ),
            ),
          );
        });
      } else {
        return const Center(
          child: Text('Error occurred.'),
        );
      }
    });
  }
}
