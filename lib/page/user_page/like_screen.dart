import 'package:flutter/material.dart';

import '../../components/ui_kit/custom_app_bar.dart';
import '../../components/widget/collection_widget.dart';

class LikeScreen extends StatelessWidget {
  final int categoryId;
  const LikeScreen({
    super.key,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        titleText: '좋아요한 컬렉션',
      ),
      body: CollectionWidget(
        categoryId: categoryId,
        isLiked: true,
        routeName: '/user',
      ),
    );
  }
}
