import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// class CollectionKeyword extends StatelessWidget {
//   final String keywordName;
//   const CollectionKeyword({super.key, required this.keywordName});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: ShapeDecoration(
//         color: Color(0xFFf1f3f5),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(50.0),
//         ),
//       ),
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 3.0.h),
//         child: Text(
//           keywordName,
//           style: TextStyle(
//             color: Color(0xFF868e96),
//             fontSize: 11.0.sp,
//             fontFamily: 'Pretendard',
//             fontWeight: FontWeight.w600,
//             height: 1.5,
//           ),
//         ),
//       ),
//     );
//   }
// }

class Keyword extends StatelessWidget {
  final String keywordName;
  const Keyword({super.key, required this.keywordName});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: Color(0xFF212529),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 3.0.h),
        child: Text(
          keywordName,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 11.0.sp,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
