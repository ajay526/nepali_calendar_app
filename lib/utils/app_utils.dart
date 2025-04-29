import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class AppUtils {
  static Future<void> shareApp(BuildContext context) async {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    try {
      final packageInfo = await PackageInfo.fromPlatform();

      String appUrl;
      if (defaultTargetPlatform == TargetPlatform.android) {
        appUrl =
            'https://play.google.com/store/apps/details?id=${packageInfo.packageName}';
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        appUrl = 'https://apps.apple.com/app/id/${packageInfo.packageName}';
      } else {
        throw UnsupportedError('Platform not supported for app sharing');
      }

      await Share.share(
        languageProvider.getText(
          'हकी पात्रो - तपाईंको दैनिक साथी। यसलाई यहाँबाट डाउनलोड गर्नुहोस्: $appUrl',
          'Hawkeye Patro - Your Daily Companion. Download it here: $appUrl',
        ),
        subject: languageProvider.getText('हकी पात्रो', 'Hawkeye Patro'),
      );
    } catch (e) {
      debugPrint('Failed to share app: $e');
      showSnackBar(
        context,
        languageProvider.getText(
          'एप साझा गर्न असफल भयो',
          'Failed to share app',
        ),
        isError: true,
      );
    }
  }

  static Future<void> openLink(BuildContext context, String url) async {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    try {
      final uri = Uri.parse(url);
      if (!await canLaunchUrl(uri)) {
        throw 'Could not launch $url';
      }

      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Failed to launch URL: $e');
      showSnackBar(
        context,
        languageProvider.getText(
          'URL खोल्न असफल भयो',
          'Failed to open URL',
        ),
        isError: true,
      );
    }
  }

  static Future<void> requestReview() async {
    final inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
      await inAppReview.requestReview();
    }
  }

  static void showSnackBar(BuildContext context, String message,
      {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  static String formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  static String formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  static String formatDateTime(DateTime dateTime) {
    return '${formatDate(dateTime)} ${formatTime(dateTime)}';
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}
