import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../components/pop_up/toast.dart';
import 'api_service.dart';
import 'image_service.dart';
import 'storage_service.dart';

class SettingService {
  static Future<Map<String, String>> getAppInfo() async {
    PackageInfo info = await PackageInfo.fromPlatform();
    return {"앱 버전": info.version};
  }

  static String _mapIosDevice(String machine) {
    switch (machine) {
      // iPhone Models
      case 'iPhone13,1':
        return 'iPhone 12 mini';
      case 'iPhone13,2':
        return 'iPhone 12';
      case 'iPhone13,3':
        return 'iPhone 12 Pro';
      case 'iPhone13,4':
        return 'iPhone 12 Pro Max';
      case 'iPhone14,4':
        return 'iPhone 13 mini';
      case 'iPhone14,5':
        return 'iPhone 13';
      case 'iPhone14,2':
        return 'iPhone 13 Pro';
      case 'iPhone14,3':
        return 'iPhone 13 Pro Max';
      case 'iPhone14,6':
        return 'iPhone SE (3rd generation)';
      case 'iPhone15,2':
        return 'iPhone 14';
      case 'iPhone15,3':
        return 'iPhone 14 Plus';
      case 'iPhone15,4':
        return 'iPhone 14 Pro';
      case 'iPhone15,5':
        return 'iPhone 14 Pro Max';
      case 'iPhone16,1':
        return 'iPhone 15';
      case 'iPhone16,2':
        return 'iPhone 15 Plus';
      case 'iPhone16,3':
        return 'iPhone 15 Pro';
      case 'iPhone16,4':
        return 'iPhone 15 Pro Max';

      // iPad Models
      case 'iPad11,1':
      case 'iPad11,2':
        return 'iPad mini (5th generation)';
      case 'iPad11,3':
      case 'iPad11,4':
        return 'iPad Air (3rd generation)';
      case 'iPad13,1':
      case 'iPad13,2':
        return 'iPad Air (4th generation)';
      case 'iPad14,1':
      case 'iPad14,2':
        return 'iPad mini (6th generation)';
      case 'iPad13,4':
      case 'iPad13,5':
      case 'iPad13,6':
      case 'iPad13,7':
        return 'iPad Pro 11-inch (3rd generation)';
      case 'iPad13,8':
      case 'iPad13,9':
      case 'iPad13,10':
      case 'iPad13,11':
        return 'iPad Pro 12.9-inch (5th generation)';
      case 'iPad13,16':
      case 'iPad13,17':
        return 'iPad Air (5th generation)';
      case 'iPad14,3':
      case 'iPad14,4':
        return 'iPad Pro 11-inch (4th generation)';
      case 'iPad14,5':
      case 'iPad14,6':
        return 'iPad Pro 12.9-inch (6th generation)';

      // iPod Models
      case 'iPod9,1':
        return 'iPod touch (7th generation)';

      // Default case for unknown models
      default:
        return machine;
    }
  }

  static Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo info) {
    var systemName = info.systemName;
    var version = info.systemVersion;
    var machine = _mapIosDevice(info.utsname.machine);

    return {"OS 버전": "$systemName $version", "기기": machine};
  }

  static Map<String, dynamic> _readAndroidDeviceInfo(AndroidDeviceInfo info) {
    var release = info.version.release;
    var sdkInt = info.version.sdkInt;
    var manufacturer = info.manufacturer;
    var model = info.model;

    return {
      "OS 버전": "Android $release (SDK $sdkInt)",
      "기기": "$manufacturer $model"
    };
  }

  static Future<Map<String, dynamic>> _getDeviceInfo(
      BuildContext context) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return _readIosDeviceInfo(iosInfo);
    } else {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return _readAndroidDeviceInfo(androidInfo);
    }
  }

  static Future<Map<String, dynamic>> _getUserInfo() async {
    final storage = FlutterSecureStorage();
    final userId = await storage.read(key: 'USER_ID');

    return {"유저 아이디": "$userId"};
  }

  static void sendEmail(BuildContext context) async {
    try {
      Map<String, dynamic> userInfo = await _getUserInfo();
      Map<String, dynamic> appInfo = await getAppInfo();
      Map<String, dynamic> deviceInfo = await _getDeviceInfo(context);

      // 이메일 본문 생성
      String emailBody = "아래 내용을 함께 보내주세요\n";
      emailBody += "==================\n";

      userInfo.forEach((key, value) {
        emailBody += "$key: $value\n";
      });

      appInfo.forEach((key, value) {
        emailBody += "$key: $value\n";
      });

      deviceInfo.forEach((key, value) {
        emailBody += "$key: $value\n";
      });

      emailBody += "==================\n";

      final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: 'contact.collecter@gmail.com',
        queryParameters: {
          'subject': '[collecter 문의]',
          'body': emailBody,
        },
      );

      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
      } else {
        Toast.showNoticeDialog(context);
      }
    } catch (e) {
      Toast.showNoticeDialog(context);
    }
  }

  static Future<bool> checkVersion() async {
    if (kDebugMode) {
      return await setDebugConfigs();
    } else {
      Map<String, String> appVersionData = await getAppInfo();
      String clientAppVersion = appVersionData['앱 버전'] ?? '';
      Map<String, String> configs = await setReleaseConfigs(clientAppVersion);
      bool needUpdate = await checkAppVersion(configs, clientAppVersion);
      return needUpdate;
    }
  }

  static Future<bool> setDebugConfigs() async {
    String supabaseTestUrl = dotenv.env['SUPABASE_TEST_URL'] ?? '';
    String supabaseTestApiKey = dotenv.env['SUPABASE_TEST_API_KEY'] ?? '';
    Map<String, String> configs = {
      'supabaseUrl': supabaseTestUrl,
      'supabaseApiKey': supabaseTestApiKey,
      'imageUrl': 'https://image.irismake.shop'
    };
    await serverInitialize(configs);
    return false;
  }

  static Future<Map<String, String>> setReleaseConfigs(
      String clientAppVersion) async {
    try {
      String apiKey = dotenv.env['AWS_API_KEY'] ?? '';
      final Uri url = Uri.parse(
          "https://wielcrs40m.execute-api.ap-northeast-2.amazonaws.com/prod?appVersion=$clientAppVersion");
      final response = await http.get(
        url,
        headers: {
          "x-api-key": "$apiKey",
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        Map<String, String> configs = {
          'supabaseUrl': data['supabaseUrl'],
          'supabaseApiKey': data['supabaseApiKey'],
          'latestAppVersion': data['latestAppVersion'],
          'imageUrl': data['imageUrl'],
          'sentryDsn': data['sentryDsn'],
        };
        return configs;
      } else {
        Toast.notify('데이터를 불러올 수 없습니다.\n잠시후에 다시 시도해주세요.');
        throw Exception('Failed to fetch Supabase config');
      }
    } catch (e, stackTrace) {
      Toast.notify('데이터를 불러올 수 없습니다.\n잠시후에 다시 시도해주세요.');
      ApiService.trackError(
          e, stackTrace, 'Exception in fetch Supabase config');
      throw Exception('Failed to fetch Supabase config');
    }
  }

  static bool needUpdate(String clientVersion, String appVersion) {
    List<String> clientParts = clientVersion.split('.');
    List<String> appParts = appVersion.split('.');

    if (clientVersion.length >= 2 && appParts.length >= 2) {
      return clientParts[0] != appParts[0] || clientParts[1] != appParts[1];
    }

    return false;
  }

  static Future<bool> checkAppVersion(
      Map<String, String> configs, String clientAppVersion) async {
    if (needUpdate(clientAppVersion, configs['latestAppVersion']!)) {
      return true;
    } else {
      await serverInitialize(configs);
      await sentryInitialize(configs);
      return false;
    }
  }

  static Future<void> serverInitialize(Map<String, String> configs) async {
    await StorageService.saveConfigs(configs['supabaseUrl']!);
    ImageService.imageUrl = configs['imageUrl']!;
    await Supabase.initialize(
      url: configs['supabaseUrl'] ?? '',
      anonKey: configs['supabaseApiKey'] ?? '',
    );
    await ApiService.authListener();
  }

  static Future<void> sentryInitialize(Map<String, String> configs) async {
    await SentryFlutter.init(
      (options) {
        options.dsn = configs['sentryDsn'] ?? '';
        options.tracesSampleRate = 1.0;
        options.profilesSampleRate = 1.0;
        options.attachStacktrace = true;
      },
    );
  }
}
