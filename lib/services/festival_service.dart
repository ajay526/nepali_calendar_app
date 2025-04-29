import 'package:nepali_utils/nepali_utils.dart';
import '../models/festival.dart';
import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart';

class FestivalService {
  static const String _boxName = 'festivals';
  late Box<Map<String, dynamic>> _festivalBox;

  Future<void> initialize() async {
    if (!Hive.isBoxOpen(_boxName)) {
      _festivalBox = await Hive.openBox<Map<String, dynamic>>(_boxName);
    } else {
      _festivalBox = Hive.box<Map<String, dynamic>>(_boxName);
    }
  }

  Future<List<Festival>> getFestivalsForMonth(int year, int month) async {
    try {
      final festivals = <Festival>[];
      final allFestivals = _festivalBox.values
          .map((e) => Festival.fromJson(Map<String, dynamic>.from(e)))
          .where((festival) {
        final festivalDate = NepaliDateTime.parse(festival.date);
        return festivalDate.year == year && festivalDate.month == month;
      }).toList();

      festivals.addAll(allFestivals);
      festivals.addAll(_getDefaultFestivals(year, month));

      return festivals;
    } catch (e) {
      debugPrint('Error getting festivals: $e');
      return [];
    }
  }

  Future<void> addFestival(Festival festival) async {
    try {
      await _festivalBox.put(festival.id, festival.toJson());
    } catch (e) {
      debugPrint('Error adding festival: $e');
      rethrow;
    }
  }

  Future<void> updateFestival(Festival festival) async {
    try {
      if (_festivalBox.containsKey(festival.id)) {
        await _festivalBox.put(festival.id, festival.toJson());
      } else {
        throw Exception('Festival not found');
      }
    } catch (e) {
      debugPrint('Error updating festival: $e');
      rethrow;
    }
  }

  Future<void> deleteFestival(String festivalId) async {
    try {
      await _festivalBox.delete(festivalId);
    } catch (e) {
      debugPrint('Error deleting festival: $e');
      rethrow;
    }
  }

  List<Festival> _getDefaultFestivals(int year, int month) {
    final festivals = <Festival>[];

    // Add default festivals based on Nepali calendar
    switch (month) {
      case 1: // Baisakh
        festivals.addAll([
          Festival(
            id: 'new_year_$year',
            name: 'Nepali New Year',
            date: NepaliDateTime(year, 1, 1).toString(),
            description: 'Beginning of the Nepali New Year',
            type: 'National',
            isPublicHoliday: true,
          ),
        ]);
        break;
      case 2: // Jestha
        festivals.addAll([
          Festival(
            id: 'buddha_jayanti_$year',
            name: 'Buddha Jayanti',
            date: NepaliDateTime(year, 2, 15).toString(), // Approximate date
            description: 'Birth anniversary of Lord Buddha',
            type: 'Religious',
            isPublicHoliday: true,
          ),
        ]);
        break;
      case 3: // Ashadh
        festivals.addAll([
          Festival(
            id: 'ropai_jatra_$year',
            name: 'Ropai Jatra',
            date: NepaliDateTime(year, 3, 15).toString(), // Approximate date
            description: 'Rice planting festival',
            type: 'Cultural',
            isPublicHoliday: false,
          ),
        ]);
        break;
      case 4: // Shrawan
        festivals.addAll([
          Festival(
            id: 'nag_panchami_$year',
            name: 'Nag Panchami',
            date: NepaliDateTime(year, 4, 5).toString(), // Approximate date
            description: 'Festival of serpent worship',
            type: 'Religious',
            isPublicHoliday: false,
          ),
        ]);
        break;
      case 5: // Bhadra
        festivals.addAll([
          Festival(
            id: 'janai_purnima_$year',
            name: 'Janai Purnima',
            date: NepaliDateTime(year, 5, 15).toString(), // Approximate date
            description: 'Sacred thread festival',
            type: 'Religious',
            isPublicHoliday: false,
          ),
        ]);
        break;
      case 6: // Ashwin
        festivals.addAll([
          Festival(
            id: 'dashain_$year',
            name: 'Dashain',
            date: NepaliDateTime(year, 6, 10).toString(), // Start date
            description:
                'Major Hindu festival celebrating victory of good over evil',
            type: 'Religious',
            isPublicHoliday: true,
            duration: 15,
          ),
        ]);
        break;
      case 7: // Kartik
        festivals.addAll([
          Festival(
            id: 'tihar_$year',
            name: 'Tihar',
            date: NepaliDateTime(year, 7, 1).toString(), // Start date
            description: 'Festival of lights',
            type: 'Religious',
            isPublicHoliday: true,
            duration: 5,
          ),
        ]);
        break;
      case 8: // Mangsir
        festivals.addAll([
          Festival(
            id: 'yomari_punhi_$year',
            name: 'Yomari Punhi',
            date: NepaliDateTime(year, 8, 15).toString(), // Approximate date
            description: 'Newari festival celebrating harvest',
            type: 'Cultural',
            isPublicHoliday: false,
          ),
        ]);
        break;
      case 9: // Poush
        festivals.addAll([
          Festival(
            id: 'tamu_lhosar_$year',
            name: 'Tamu Lhosar',
            date: NepaliDateTime(year, 9, 15).toString(), // Approximate date
            description: 'Gurung New Year',
            type: 'Cultural',
            isPublicHoliday: true,
          ),
        ]);
        break;
      case 10: // Magh
        festivals.addAll([
          Festival(
            id: 'maghe_sankranti_$year',
            name: 'Maghe Sankranti',
            date: NepaliDateTime(year, 10, 1).toString(),
            description: 'Beginning of auspicious month of Magh',
            type: 'Cultural',
            isPublicHoliday: false,
          ),
        ]);
        break;
      case 11: // Falgun
        festivals.addAll([
          Festival(
            id: 'holi_$year',
            name: 'Holi',
            date: NepaliDateTime(year, 11, 15).toString(), // Approximate date
            description: 'Festival of colors',
            type: 'Religious',
            isPublicHoliday: true,
          ),
        ]);
        break;
      case 12: // Chaitra
        festivals.addAll([
          Festival(
            id: 'ghode_jatra_$year',
            name: 'Ghode Jatra',
            date: NepaliDateTime(year, 12, 15).toString(), // Approximate date
            description: 'Festival of horses',
            type: 'Cultural',
            isPublicHoliday: true,
          ),
        ]);
        break;
    }

    return festivals;
  }
}
