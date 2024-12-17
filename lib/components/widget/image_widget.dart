import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../data/services/image_service.dart';

class ImageWidget extends StatelessWidget {
  final String storageFolderName;
  final String imageFilePath;
  final double borderRadius;

  const ImageWidget({
    Key? key,
    required this.storageFolderName,
    required this.imageFilePath,
    required this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String _imageUrl =
        ImageService.getFullImageUrl(storageFolderName, imageFilePath);

    return CachedNetworkImage(
        imageUrl: _imageUrl,
        imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(
                  color: const Color(0xFFdee2e6),
                  width: 0.5.w,
                ),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
        errorListener: (error) {
          //this is never called when running on the web!
          print("CachedNetworkImageProvider: Image failed to load!");
        },
        errorWidget: (context, url, error) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(
                  color: const Color(0xFFdee2e6),
                  width: 0.5.w,
                ),
              ),
              color: Color(0xFFf1f3f5),
            ));
  }
}
