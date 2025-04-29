import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../config/app_config.dart';

class SecurityService {
  static final SecurityService _instance = SecurityService._internal();
  factory SecurityService() => _instance;
  SecurityService._internal();

  final _storage = const FlutterSecureStorage();
  final _uuid = const Uuid();
  final _deviceInfo = DeviceInfoPlugin();
  String? _deviceId;
  String? _appSignature;
  final _appConfig = AppConfig();

  Future<void> initialize() async {
    await _checkEmulator();
    await _generateDeviceId();
    await _generateAppSignature();
    await _verifyAppIntegrity();
  }

  Future<void> _checkEmulator() async {
    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
      if (androidInfo.isPhysicalDevice == false) {
        throw Exception('Emulators are not allowed');
      }
    } else if (Platform.isIOS) {
      final iosInfo = await _deviceInfo.iosInfo;
      if (iosInfo.isPhysicalDevice == false) {
        throw Exception('Simulators are not allowed');
      }
    }
  }

  Future<void> _generateDeviceId() async {
    _deviceId = await _storage.read(key: 'device_id') ?? _uuid.v4();
    await _storage.write(key: 'device_id', value: _deviceId);
  }

  Future<void> _generateAppSignature() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final appName = packageInfo.appName;
    final packageName = packageInfo.packageName;
    final version = packageInfo.version;
    final buildNumber = packageInfo.buildNumber;

    final signatureData = '$appName$packageName$version$buildNumber';
    _appSignature = sha256.convert(utf8.encode(signatureData)).toString();
  }

  Future<void> _verifyAppIntegrity() async {
    if (kDebugMode) return; // Skip in debug mode

    final storedSignature = await _storage.read(key: 'app_signature');
    if (storedSignature != _appSignature) {
      throw Exception('App integrity check failed');
    }
  }

  Future<bool> verifyLicense() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.hawkeyepatro.com/verify-license'),
        headers: {
          'X-Device-ID': _deviceId!,
          'X-App-Signature': _appSignature!,
          'X-Platform': Platform.operatingSystem,
          'X-App-Version': (await PackageInfo.fromPlatform()).version,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['valid'] == true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  String encryptData(String data) {
    final key = utf8.encode(_appSignature ?? 'default_key');
    final iv = utf8.encode(_deviceId ?? 'default_iv');
    final bytes = utf8.encode(data);

    final hmac = Hmac(sha256, List.from(key)..addAll(iv));
    final digest = hmac.convert(bytes);

    return base64.encode(digest.bytes);
  }

  String decryptData(String encryptedData) {
    // Note: This is a one-way hash, we can't decrypt it
    // In production, use proper encryption/decryption
    return encryptedData;
  }

  Future<void> protectSensitiveData() async {
    // Store API keys securely
    await _storage.write(
      key: 'news_api_key',
      value: encryptData(_appConfig.newsApiKey),
    );
    await _storage.write(
      key: 'forex_api_key',
      value: encryptData(_appConfig.forexApiKey),
    );
  }

  Future<String?> getSecureApiKey(String key) async {
    final encryptedKey = await _storage.read(key: key);
    return encryptedKey != null ? decryptData(encryptedKey) : null;
  }

  Future<void> clearSecureData() async {
    await _storage.deleteAll();
  }

  Future<bool> isAppModified() async {
    if (kDebugMode) return false; // Skip in debug mode

    final currentSignature = _appSignature;
    final storedSignature = await _storage.read(key: 'app_signature');

    return currentSignature != storedSignature;
  }

  bool isDebuggingEnabled() {
    return kDebugMode;
  }

  Future<bool> isRunningOnEmulator() async {
    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
      return !androidInfo.isPhysicalDevice;
    } else if (Platform.isIOS) {
      final iosInfo = await _deviceInfo.iosInfo;
      return !iosInfo.isPhysicalDevice;
    }
    return false;
  }

  Future<Map<String, dynamic>> getDeviceInfo() async {
    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
      return {
        'platform': 'Android',
        'model': androidInfo.model,
        'manufacturer': androidInfo.manufacturer,
        'version': androidInfo.version.release,
        'isPhysicalDevice': androidInfo.isPhysicalDevice,
      };
    } else if (Platform.isIOS) {
      final iosInfo = await _deviceInfo.iosInfo;
      return {
        'platform': 'iOS',
        'model': iosInfo.model,
        'systemVersion': iosInfo.systemVersion,
        'isPhysicalDevice': iosInfo.isPhysicalDevice,
      };
    }
    return {'platform': Platform.operatingSystem};
  }
}
