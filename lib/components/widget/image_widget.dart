import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../data/services/image_service.dart';

class ImageWidget extends StatelessWidget {
  final String storageFolderName;
  final String imageFilePath;
  final double boarderRadius;

  ImageWidget({
    super.key,
    required this.storageFolderName,
    required this.imageFilePath,
    required this.boarderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: ImageService.getFullImageUrl(
        storageFolderName,
        imageFilePath,
      ),
      builder: (context, snapshot) {
        return CachedNetworkImage(
          imageUrl: snapshot.data ?? '',
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(boarderRadius),
              border: Border.all(
                color: Color(0xFFdee2e6),
                width: 0.5.w,
              ),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          errorWidget: (context, url, error) => Center(child: Text('No data')),
        );
      },
    );
  }
}
