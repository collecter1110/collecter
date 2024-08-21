import 'package:collect_er/components/card/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CollectionWidget extends StatelessWidget {
  final bool isMyCollection;
  const CollectionWidget({super.key, required this.isMyCollection});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 18.0.w,
        vertical: 20.0.h,
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 24.0.h,
          crossAxisSpacing: 12.0.w,
          childAspectRatio: 0.65,
        ),
        itemCount: 7,
        itemBuilder: (context, index) {
          return isMyCollection
              ? Collection(
                  index: index,
                )
              : Container(
                  color: Colors.pink,
                );
        },
      ),
    );
  }
}
