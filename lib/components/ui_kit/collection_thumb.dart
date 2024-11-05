import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CollectionThumb extends StatelessWidget {
  const CollectionThumb({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        color: Colors.transparent,
        child: GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
            childAspectRatio: 1,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            return index == 0
                ? Image.asset(
                    'assets/images/IMG_4498.png',
                    fit: BoxFit.cover,
                  )
                : Container(
                    color: Color(0xFFF1F3F5),
                  );
          },
        ),
      ),
    );
  }
}
