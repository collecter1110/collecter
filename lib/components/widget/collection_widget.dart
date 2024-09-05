import 'package:collect_er/components/card/collection.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/model/collection_model.dart';
import '../../data/provider/collection_provider.dart';

class CollectionWidget extends StatelessWidget {
  const CollectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CollectionProvider>(builder: (context, provider, child) {
      final List<CollectionModel>? _collections = provider.getCollections();
      if (provider.state == ConnectionState.waiting) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (provider.state == ConnectionState.done) {
        return GridView.builder(
          padding: EdgeInsets.symmetric(vertical: 22.0.h, horizontal: 16.0.w),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 24.0.h,
            crossAxisSpacing: 12.0.w,
            childAspectRatio: 0.65,
          ),
          itemCount: _collections?.length ?? 0,
          itemBuilder: (context, index) {
            final CollectionModel _collection = _collections![index];

            return Collection(
              title: _collection.title,
              imageFilePath: _collection.imageFilePath,
              primaryKeywords: _collection.primaryKeywords,
              selectionNum: _collection.selectionNum,
            );
          },
        );
      } else {
        return const Center(
          child: Text('Error occurred.'),
        );
      }
    });
  }
}
