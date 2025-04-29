class DateConverter {
  static const List<int> _daysInNepaliMonth = [31, 31, 32, 32, 31, 30, 30, 29, 30, 29, 30, 30];
  
  static final DateTime _startDate = DateTime(1943, 4, 14); // Base date for conversion
  static const int _startNepaliYear = 2000;
  static const int _startNepaliMonth = 1;
  static const int _startNepaliDay = 1;

  static Map<String, int> convertADToBS(DateTime ad) {
    int totalDays = ad.difference(_startDate).inDays;
    
    int nepaliYear = _startNepaliYear;
    int nepaliMonth = _startNepaliMonth;
    int nepaliDay = _startNepaliDay;

    // Calculate year
    while (totalDays > 365) {
      totalDays -= _isLeapYear(nepaliYear) ? 366 : 365;
      nepaliYear++;
    }

    // Calculate month and day
    for (int i = 0; i < 12; i++) {
      if (totalDays > _daysInNepaliMonth[i]) {
        totalDays -= _daysInNepaliMonth[i];
        nepaliMonth++;
      } else {
        nepaliDay = totalDays + 1;
        break;
      }
    }

    return {
      'year': nepaliYear,
      'month': nepaliMonth,
      'day': nepaliDay,
    };
  }

  static DateTime convertBSToAD(int year, int month, int day) {
    int totalDays = 0;

    // Add days for years
    for (int i = _startNepaliYear; i < year; i++) {
      totalDays += _isLeapYear(i) ? 366 : 365;
    }

    // Add days for months
    for (int i = 0; i < month - 1; i++) {
      totalDays += _daysInNepaliMonth[i];
    }

    // Add days
    totalDays += day - 1;

    return _startDate.add(Duration(days: totalDays));
  }

  static bool _isLeapYear(int year) {
    if (year % 4 == 0) {
      if (year % 100 == 0) {
        return year % 400 == 0;
      }
      return true;
    }
    return false;
  }

  static String formatNepaliDate(int year, int month, int day) {
    return '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  }

  static String formatEnglishDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
