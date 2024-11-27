import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../components/pop_up/toast.dart';

class ImageService {
  static final _storage = FlutterSecureStorage();

  static Future<String> getFullImageUrl(
      String storageFolderName, String imageFilePath) async {
    final String supabaseUrl = await _storage.read(key: 'SUPABASE_URL') ?? '';

    return '$supabaseUrl/storage/v1/object/public/images/$storageFolderName/$imageFilePath';
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
