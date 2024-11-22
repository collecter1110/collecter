import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../data/services/image_service.dart';

class ImageWidget extends StatefulWidget {
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
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  Future<String>? _imageUrlFuture;

  @override
  void initState() {
    super.initState();
    _imageUrlFuture = ImageService.getFullImageUrl(
      widget.storageFolderName,
      widget.imageFilePath,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _imageUrlFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox.shrink();
        } else if (snapshot.hasData) {
          return CachedNetworkImage(
            imageUrl: snapshot.data ?? '',
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.boarderRadius),
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
            errorWidget: (context, url, error) =>
                Center(child: Text('No data')),
          );
        } else {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
      },
    );
  }
}
