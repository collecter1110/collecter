import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../components/pop_up/toast.dart';

class StorageService {
  static String getFullImageUrl(
      String storageFolderName, String imageFilePath) {
    // 환경 변수에서 Supabase URL 가져오기
    final String supabaseUrl = dotenv.env['SUPABASE_TEST_URL'] ?? '';

    // 전체 URL 생성 (버킷 이름과 폴더 경로 포함)
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
