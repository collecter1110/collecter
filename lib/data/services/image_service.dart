import 'package:permission_handler/permission_handler.dart';

import '../../components/pop_up/toast.dart';

class ImageService {
  static String? imageUrl;

  static String getFullImageUrl(
      String storageFolderName, String imageFilePath) {
    if (imageUrl == null) {
      throw Exception('Failed to fetch image url');
    }
    return '$imageUrl/$storageFolderName/$imageFilePath';
  }

  static Future<void> getPermission() async {
    bool isPermissionGranted = await requestPhotoPermission();

    if (isPermissionGranted) {
    } else {
      openAppSettings();
    }
  }

  static Future<bool> requestPhotoPermission() async {
    PermissionStatus status = await Permission.photos.request();

    if (status.isGranted || status.isLimited) {
      return true;
    } else {
      await Toast.handlePhotoPermission(status);
      return false;
    }
  }
}
