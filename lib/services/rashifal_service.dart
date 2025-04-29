import 'dart:math';

class RashifalService {
  static final Map<String, Map<String, dynamic>> _rashiCharacteristics = {
    'Mesh': {
      'element': 'Fire',
      'lucky_numbers': [1, 9],
      'lucky_colors': ['Red', 'Orange'],
      'lucky_days': ['Tuesday', 'Sunday'],
      'lucky_stones': ['Ruby', 'Coral'],
    },
    'Vrishabha': {
      'element': 'Earth',
      'lucky_numbers': [2, 7],
      'lucky_colors': ['Green', 'White'],
      'lucky_days': ['Friday', 'Monday'],
      'lucky_stones': ['Diamond', 'Emerald'],
    },
    'Mithun': {
      'element': 'Air',
      'lucky_numbers': [3, 6],
      'lucky_colors': ['Yellow', 'Green'],
      'lucky_days': ['Wednesday', 'Sunday'],
      'lucky_stones': ['Emerald', 'Pearl'],
    },
    'Karka': {
      'element': 'Water',
      'lucky_numbers': [2, 7],
      'lucky_colors': ['White', 'Silver'],
      'lucky_days': ['Monday', 'Thursday'],
      'lucky_stones': ['Pearl', 'Moonstone'],
    },
    'Simha': {
      'element': 'Fire',
      'lucky_numbers': [1, 5],
      'lucky_colors': ['Gold', 'Orange'],
      'lucky_days': ['Sunday', 'Tuesday'],
      'lucky_stones': ['Ruby', 'Topaz'],
    },
    'Kanya': {
      'element': 'Earth',
      'lucky_numbers': [5, 8],
      'lucky_colors': ['Green', 'Brown'],
      'lucky_days': ['Wednesday', 'Friday'],
      'lucky_stones': ['Emerald', 'Yellow Sapphire'],
    },
    'Tula': {
      'element': 'Air',
      'lucky_numbers': [6, 9],
      'lucky_colors': ['White', 'Pink'],
      'lucky_days': ['Friday', 'Wednesday'],
      'lucky_stones': ['Diamond', 'Opal'],
    },
    'Vrishchika': {
      'element': 'Water',
      'lucky_numbers': [1, 8],
      'lucky_colors': ['Red', 'Maroon'],
      'lucky_days': ['Tuesday', 'Thursday'],
      'lucky_stones': ['Coral', 'Pearl'],
    },
    'Dhanu': {
      'element': 'Fire',
      'lucky_numbers': [3, 9],
      'lucky_colors': ['Yellow', 'Orange'],
      'lucky_days': ['Thursday', 'Tuesday'],
      'lucky_stones': ['Yellow Sapphire', 'Ruby'],
    },
    'Makar': {
      'element': 'Earth',
      'lucky_numbers': [4, 8],
      'lucky_colors': ['Blue', 'Black'],
      'lucky_days': ['Saturday', 'Friday'],
      'lucky_stones': ['Blue Sapphire', 'Diamond'],
    },
    'Kumbha': {
      'element': 'Air',
      'lucky_numbers': [4, 7],
      'lucky_colors': ['Blue', 'Purple'],
      'lucky_days': ['Saturday', 'Friday'],
      'lucky_stones': ['Blue Sapphire', 'Amethyst'],
    },
    'Meen': {
      'element': 'Water',
      'lucky_numbers': [3, 9],
      'lucky_colors': ['Sea Green', 'Purple'],
      'lucky_days': ['Thursday', 'Monday'],
      'lucky_stones': ['Yellow Sapphire', 'Pearl'],
    },
  };

  static Map<String, dynamic> getRashiCharacteristics(String rashi) {
    return _rashiCharacteristics[rashi] ?? {};
  }

  static Map<String, String> getPrediction(String rashi, String type) {
    final random = Random();
    final characteristics = getRashiCharacteristics(rashi);
    
    final predictions = {
      'daily': [
        'आजको दिन तपाईंको लागि ${characteristics['element']} तत्वको प्रभाव उच्च रहनेछ।',
        'भाग्यशाली रंग ${characteristics['lucky_colors'].join(' वा ')} प्रयोग गर्दा फाइदा हुनेछ।',
        'आज ${characteristics['lucky_days'].join(' वा ')} को प्रभाव रहनेछ।',
      ],
      'weekly': [
        'यो हप्ता ${characteristics['lucky_stones'].join(' वा ')} धारण गर्नाले शुभ फल प्राप्त हुनेछ।',
        'भाग्यशाली अंक ${characteristics['lucky_numbers'].join(' वा ')} को प्रयोग गर्दा लाभदायक हुनेछ।',
        'हप्ताको ${characteristics['lucky_days'].join(' र ')} विशेष महत्वपूर्ण रहनेछन्।',
      ],
      'monthly': [
        'यस महिना ${characteristics['element']} तत्वसँग सम्बन्धित कार्यहरू गर्दा सफलता मिल्नेछ।',
        'महिनाभर ${characteristics['lucky_colors'].join(' वा ')} रंगको प्रयोग शुभ रहनेछ।',
        '${characteristics['lucky_stones'].join(' वा ')} रत्न धारण गर्नाले विशेष लाभ हुनेछ।',
      ],
    };

    final selectedPredictions = predictions[type] ?? [];
    return {
      'prediction': selectedPredictions[random.nextInt(selectedPredictions.length)],
      'lucky_numbers': characteristics['lucky_numbers'].join(', '),
      'lucky_colors': characteristics['lucky_colors'].join(', '),
      'lucky_days': characteristics['lucky_days'].join(', '),
      'lucky_stones': characteristics['lucky_stones'].join(', '),
    };
  }
}
