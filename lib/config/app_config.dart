import 'package:flutter_dotenv/flutter_dotenv.dart';

class Ad {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String linkUrl;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;

  Ad({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.linkUrl,
    required this.startDate,
    required this.endDate,
    required this.isActive,
  });
}

class ContactInfo {
  final String email;
  final String phone;
  final String address;
  final String website;
  final Map<String, String> socialMedia;

  ContactInfo({
    required this.email,
    required this.phone,
    required this.address,
    required this.website,
    required this.socialMedia,
  });
}

class JyotishProfile {
  final String id;
  final String name;
  final String englishName;
  final String imageUrl;
  final String description;
  final String contactUrl;
  final bool isActive;

  JyotishProfile({
    required this.id,
    required this.name,
    required this.englishName,
    required this.imageUrl,
    required this.description,
    required this.contactUrl,
    required this.isActive,
  });
}

class AppConfig {
  static final AppConfig _instance = AppConfig._internal();
  factory AppConfig() => _instance;
  AppConfig._internal();

  static Future<void> initialize() async {
    await dotenv.load();
  }

  // ✅ Add missing getters here
  String get newsApiKey => dotenv.env['NEWS_API_KEY'] ?? '';
  String get forexApiKey => dotenv.env['FOREX_API_KEY'] ?? '';

  String get appName => dotenv.env['APP_NAME'] ?? 'Hawkeye Patro';
  String get appVersion => dotenv.env['APP_VERSION'] ?? '1.0.0';
  int get appBuildNumber =>
      int.tryParse(dotenv.env['APP_BUILD_NUMBER'] ?? '') ?? 1;

  static final List<Ad> ads = [
    Ad(
      id: '1',
      title: 'Special Offer',
      description: 'Get 20% off on all services',
      imageUrl: 'assets/images/ad1.png',
      linkUrl: 'https://example.com/offer',
      startDate: DateTime(2024, 1, 1),
      endDate: DateTime(2025, 12, 31),
      isActive: true,
    ),
  ];

  static final ContactInfo contactInfo = ContactInfo(
    email: 'info@hawkeye_patro.com',
    phone: '+9779865502029',
    address: 'Karra -04, Hetauda, Makwanpur, Nepal',
    website: 'www.hawkeye-patro.com',
    socialMedia: {
      'facebook': 'https://facebook.com/hawkeye.patro',
      'twitter': 'https://twitter.com/hawkeye_patro',
      'instagram': 'https://instagram.com/hawkeye.patro',
    },
  );

  static final List<JyotishProfile> jyotishProfiles = [
    JyotishProfile(
      id: '1',
      name: 'पंडित राम प्रसाद आचार्य',
      englishName: 'Pandit Ram Prasad Acharya',
      imageUrl: 'assets/images/jyotish1.png',
      description: '30 years of experience in Vedic astrology',
      contactUrl: 'https://wa.me/9779865502029',
      isActive: true,
    ),
    JyotishProfile(
      id: '2',
      name: 'पंडित कृष्ण प्रसाद शर्मा',
      englishName: 'Pandit Krishna Prasad Sharma',
      imageUrl: 'assets/images/jyotish2.png',
      description: '25 years of experience in Nakshatra',
      contactUrl: 'https://wa.me/9779865502029',
      isActive: true,
    ),
    JyotishProfile(
      id: '3',
      name: 'पंडित देवी प्रसाद रिजाल',
      englishName: 'Pandit Devi Prasad Rijal',
      imageUrl: 'assets/images/jyotish3.png',
      description: '20 years of experience in Kundali',
      contactUrl: 'https://wa.me/9779865502029',
      isActive: true,
    ),
    JyotishProfile(
      id: '4',
      name: 'पंडित गणेश प्रसाद सुवेदी',
      englishName: 'Pandit Ganesh Prasad Subedi',
      imageUrl: 'assets/images/jyotish4.png',
      description: '15 years of experience in Vastu',
      contactUrl: 'https://wa.me/9779865502029',
      isActive: true,
    ),
  ];

  static void updateJyotishProfile(JyotishProfile updatedProfile) {
    final index = jyotishProfiles.indexWhere((p) => p.id == updatedProfile.id);
    if (index != -1) {
      jyotishProfiles[index] = updatedProfile;
    }
  }
}
