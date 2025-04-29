import 'package:nepali_utils/nepali_utils.dart';
import '../models/panchanga.dart';
import 'package:hive/hive.dart';

class PanchangaService {
  static const String _boxName = 'panchanga_data';
  late Box<Map<String, dynamic>> _panchangaBox;

  Future<void> initialize() async {
    if (!Hive.isBoxOpen(_boxName)) {
      _panchangaBox = await Hive.openBox<Map<String, dynamic>>(_boxName);
    } else {
      _panchangaBox = Hive.box<Map<String, dynamic>>(_boxName);
    }
  }

  Future<Panchanga> getPanchangaForDate(NepaliDateTime date) async {
    final key = date.toString().split(' ')[0]; // Use only the date part as key
    final stored = _panchangaBox.get(key);

    if (stored != null) {
      return Panchanga.fromJson(Map<String, dynamic>.from(stored));
    }

    // If not in cache, calculate new panchanga
    final panchanga = await _calculatePanchanga(date);
    await _panchangaBox.put(key, panchanga.toJson());
    return panchanga;
  }

  Future<Panchanga> _calculatePanchanga(NepaliDateTime date) async {
    // This is where you would implement the actual Panchanga calculations
    final moonPhase = _calculateMoonPhase(date);
    final yoga = _calculateYoga(date);
    return Panchanga(
      date: date,
      tithi: _calculateTithi(date),
      nakshatra: _calculateNakshatra(date),
      yoga: yoga,
      karana: _calculateKarana(date),
      shubhaSait: _getShubhaSait(date),
      ashubhaSait: _getAshubhaSait(date),
      moonPhase: moonPhase,
      isAuspiciousYoga: _isAuspiciousYoga(yoga),
    );
  }

  String _calculateTithi(NepaliDateTime date) {
    final day = date.day % 30;
    final tithis = [
      'Pratipada',
      'Dwitiya',
      'Tritiya',
      'Chaturthi',
      'Panchami',
      'Shashthi',
      'Saptami',
      'Ashtami',
      'Navami',
      'Dashami',
      'Ekadashi',
      'Dwadashi',
      'Trayodashi',
      'Chaturdashi',
      'Purnima',
      'Pratipada',
      'Dwitiya',
      'Tritiya',
      'Chaturthi',
      'Panchami',
      'Shashthi',
      'Saptami',
      'Ashtami',
      'Navami',
      'Dashami',
      'Ekadashi',
      'Dwadashi',
      'Trayodashi',
      'Chaturdashi',
      'Amavasya'
    ];
    return tithis[day];
  }

  String _calculateNakshatra(NepaliDateTime date) {
    final day = (date.day + date.month) % 27;
    final nakshatras = [
      'Ashwini',
      'Bharani',
      'Krittika',
      'Rohini',
      'Mrigashira',
      'Ardra',
      'Punarvasu',
      'Pushya',
      'Ashlesha',
      'Magha',
      'Purva Phalguni',
      'Uttara Phalguni',
      'Hasta',
      'Chitra',
      'Swati',
      'Vishakha',
      'Anuradha',
      'Jyeshtha',
      'Mula',
      'Purva Ashadha',
      'Uttara Ashadha',
      'Shravana',
      'Dhanishta',
      'Shatabhisha',
      'Purva Bhadrapada',
      'Uttara Bhadrapada',
      'Revati'
    ];
    return nakshatras[day];
  }

  String _calculateMoonPhase(NepaliDateTime date) {
    final tithi = _calculateTithi(date);
    if (tithi == 'Purnima') return 'Full Moon';
    if (tithi == 'Amavasya') return 'New Moon';
    if (tithi.startsWith('Pratipada') || tithi.startsWith('Dwitiya'))
      return 'Waxing Crescent';
    if (tithi.startsWith('Tritiya') || tithi.startsWith('Chaturthi'))
      return 'First Quarter';
    if (tithi.startsWith('Panchami') || tithi.startsWith('Shashthi'))
      return 'Waxing Gibbous';
    if (tithi.startsWith('Saptami') || tithi.startsWith('Ashtami'))
      return 'Last Quarter';
    return 'Waning Crescent';
  }

  bool _isAuspiciousYoga(String yoga) {
    final auspiciousYogas = [
      'Siddhi',
      'Shubha',
      'Shukla',
      'Brahma',
      'Indra',
      'Priti',
      'Ayushman',
      'Saubhagya',
      'Shobhana',
      'Sukarman'
    ];
    return auspiciousYogas.contains(yoga);
  }

  String _calculateYoga(NepaliDateTime date) {
    final day = (date.day + date.month + date.year % 100) % 27;
    final yogas = [
      'Vishkumbha',
      'Priti',
      'Ayushman',
      'Saubhagya',
      'Shobhana',
      'Atiganda',
      'Sukarman',
      'Dhriti',
      'Shula',
      'Ganda',
      'Vriddhi',
      'Dhruva',
      'Vyaghata',
      'Harshana',
      'Vajra',
      'Siddhi',
      'Vyatipata',
      'Variyan',
      'Parigha',
      'Shiva',
      'Siddha',
      'Sadhya',
      'Shubha',
      'Shukla',
      'Brahma',
      'Indra',
      'Vaidhriti'
    ];
    return yogas[day];
  }

  String _calculateKarana(NepaliDateTime date) {
    final day = date.day % 11;
    final karanas = [
      'Bava',
      'Balava',
      'Kaulava',
      'Taitila',
      'Garija',
      'Vanija',
      'Vishti',
      'Shakuni',
      'Chatushpada',
      'Naga',
      'Kimstughna'
    ];
    return karanas[day];
  }

  List<String> _getShubhaSait(NepaliDateTime date) {
    final weekDay = date.weekday;
    final List<String> shubhaSait = [];

    if (weekDay == 1 || weekDay == 4 || weekDay == 7) {
      shubhaSait.add('6:00 - 7:30');
    }
    if (weekDay == 2 || weekDay == 5) {
      shubhaSait.add('14:00 - 15:30');
    }
    if (weekDay == 3 || weekDay == 6) {
      shubhaSait.add('18:00 - 19:30');
    }

    return shubhaSait;
  }

  List<String> _getAshubhaSait(NepaliDateTime date) {
    final weekDay = date.weekday;
    final List<String> ashubhaSait = [];

    if (weekDay == 1 || weekDay == 7) {
      ashubhaSait.add('4:30 - 6:00');
    }
    if (weekDay == 2 || weekDay == 5) {
      ashubhaSait.add('12:00 - 13:30');
    }
    if (weekDay == 3 || weekDay == 6) {
      ashubhaSait.add('21:00 - 22:30');
    }

    return ashubhaSait;
  }
}
