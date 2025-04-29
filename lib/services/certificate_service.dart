import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CertificateService {
  static final CertificateService _instance = CertificateService._internal();
  factory CertificateService() => _instance;
  CertificateService._internal();

  static const String _certificatesKey = 'ssl_certificates';
  late SharedPreferences _prefs;
  List<Map<String, String>> _certificates = [];
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    _prefs = await SharedPreferences.getInstance();
    await _loadCertificates();
    _isInitialized = true;
  }

  Future<void> _loadCertificates() async {
    try {
      final certificatesJson = _prefs.getStringList(_certificatesKey);
      if (certificatesJson != null) {
        _certificates = certificatesJson
            .map((cert) => Map<String, String>.from(json.decode(cert)))
            .toList();
      } else {
        _certificates = [
          {
            'cert':
                'MIIF6TCCBNGgAwIBAgIQBffjbSRu81JTaCJ3Mmc5MDANBgkqhkiG9w0BAQsFADBG',
            'host': 'api.hawkeyepatro.com',
            'expiry': '2024-12-31',
            'fingerprint':
                '1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef'
          }
        ];
        await _saveCertificates();
      }
    } catch (e) {
      debugPrint('Failed to load certificates: $e');
      _certificates = [];
    }
  }

  Future<void> _saveCertificates() async {
    try {
      final certificatesJson =
          _certificates.map((cert) => json.encode(cert)).toList();
      await _prefs.setStringList(_certificatesKey, certificatesJson);
    } catch (e) {
      debugPrint('Failed to save certificates: $e');
    }
  }

  Future<void> addCertificate(Map<String, String> certificate) async {
    if (!_isInitialized) await initialize();

    if (!_isValidCertificate(certificate)) {
      throw SecurityException('Invalid certificate format');
    }

    _certificates.add(certificate);
    await _saveCertificates();
  }

  bool _isValidCertificate(Map<String, String> certificate) {
    return certificate.containsKey('cert') &&
        certificate.containsKey('host') &&
        certificate.containsKey('expiry') &&
        certificate.containsKey('fingerprint');
  }

  Future<bool> checkCertificate(String url) async {
    if (!_isInitialized) await initialize();

    try {
      final host = Uri.parse(url).host;
      final certificates =
          _certificates.where((cert) => cert['host'] == host).toList();

      if (certificates.isEmpty) {
        debugPrint('No certificates found for host: $host');
        return false;
      }

      for (final cert in certificates) {
        // Certificate expiration check (without SSL pinning)
        final expiryDate = DateTime.parse(cert['expiry']!);
        if (DateTime.now().isAfter(expiryDate)) {
          debugPrint('Certificate expired for host: $host');
          return false;
        }

        // NOTE: SSL pinning check skipped
        debugPrint('SSL pinning check skipped for host: $host');
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('Failed to check certificate: $e');
      return false;
    }
  }

  Future<void> verifyCertificate(String url) async {
    if (!_isInitialized) await initialize();

    final isValid = await checkCertificate(url);
    if (!isValid) {
      throw SecurityException(
        'Invalid or expired SSL certificate for ${Uri.parse(url).host}',
      );
    }
  }

  Future<void> removeCertificate(String host) async {
    if (!_isInitialized) await initialize();

    _certificates.removeWhere((cert) => cert['host'] == host);
    await _saveCertificates();
  }

  List<Map<String, String>> getCertificates() {
    return List.unmodifiable(_certificates);
  }
}

class SecurityException implements Exception {
  final String message;
  SecurityException(this.message);

  @override
  String toString() => 'SecurityException: $message';
}
