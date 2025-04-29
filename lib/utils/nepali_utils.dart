class NepaliUtils {
  static const List<String> _nepaliMonths = [
    'बैशाख',
    'जेठ',
    'असार',
    'साउन',
    'भदौ',
    'असोज',
    'कार्तिक',
    'मंसिर',
    'पुष',
    'माघ',
    'फागुन',
    'चैत',
  ];

  static const List<String> _englishMonths = [
    'Baisakh',
    'Jestha',
    'Asar',
    'Shrawan',
    'Bhadra',
    'Ashwin',
    'Kartik',
    'Mangsir',
    'Poush',
    'Magh',
    'Falgun',
    'Chaitra',
  ];

  static const List<int> _daysInMonth = [
    31, 31, 32, 32, 31, 31, 30, 29, 30, 29, 30, 30, // 2080
    31, 31, 32, 32, 31, 31, 30, 29, 30, 29, 30, 30, // 2081
    31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 31, // 2082
  ];

  static String getNepaliMonthName(int month) {
    if (month < 1 || month > 12) {
      throw ArgumentError('Month must be between 1 and 12');
    }
    return _nepaliMonths[(month - 1) % 12];
  }

  static String getEnglishMonthName(int month) {
    if (month < 1 || month > 12) {
      throw ArgumentError('Month must be between 1 and 12');
    }
    return _englishMonths[(month - 1) % 12];
  }

  static int getDaysInMonth(int year, int month) {
    if (month < 1 || month > 12) {
      throw ArgumentError('Month must be between 1 and 12');
    }

    // For now, using a fixed pattern for 2080-2082
    // In a real app, you would have a complete data table for many years
    final yearOffset = (year - 2080) * 12;
    final monthIndex = yearOffset + (month - 1);
    
    if (monthIndex < 0 || monthIndex >= _daysInMonth.length) {
      return 30; // Default fallback
    }
    
    return _daysInMonth[monthIndex];
  }

  static int getFirstDayOfMonth(int year, int month) {
    // This is a simplified implementation
    // In a real app, you would calculate this based on the actual Nepali calendar rules
    // For now, we'll use some sample first days that look natural
    final yearOffset = (year - 2080) * 12;
    final monthIndex = yearOffset + (month - 1);
    return (monthIndex * 2 + 3) % 7;
  }

  static bool isLeapYear(int year) {
    // Simplified implementation
    // In a real app, you would use actual Nepali calendar rules
    return year % 4 == 0;
  }

  static String formatDate(Map<String, int> date) {
    return '${date['year']}-${date['month'].toString().padLeft(2, '0')}-${date['day'].toString().padLeft(2, '0')}';
  }

  static String formatDateBS(Map<String, int> date) {
    return '${date['day']} ${getNepaliMonthName(date['month']!)} ${date['year']}';
  }
}
