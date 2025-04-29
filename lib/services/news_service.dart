class NewsService {
  static Future<List<Map<String, dynamic>>> getNews() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      {
        'title': 'नयाँ वर्ष २०८१ को शुभकामना',
        'description': 'नेपाली नयाँ वर्ष २०८१ को अवसरमा सम्पूर्ण नेपाली दाजुभाई तथा दिदीबहिनीहरूमा हार्दिक मंगलमय शुभकामना व्यक्त गर्दछौं।',
        'imageUrl': 'assets/images/news/newyear.jpg',
        'date': '2081-01-01',
        'source': 'हकआइ पात्रो',
      },
      {
        'title': 'आजको राशिफल',
        'description': 'आजको दिन मेष राशिका लागि शुभ छ। आर्थिक लाभका साथै नयाँ अवसरहरू प्राप्त हुनेछन्।',
        'imageUrl': 'assets/images/news/horoscope.jpg',
        'date': '2081-01-01',
        'source': 'ज्योतिष विभाग',
      },
      {
        'title': 'आजको पञ्चाङ्ग',
        'description': 'आज वैशाख १ गते २०८१, सोमबार। आजको तिथि प्रतिपदा, नक्षत्र अश्विनी, योग विष्कुम्भ।',
        'imageUrl': 'assets/images/news/panchang.jpg',
        'date': '2081-01-01',
        'source': 'पञ्चाङ्ग विभाग',
      },
      {
        'title': 'साप्ताहिक मौसम पूर्वानुमान',
        'description': 'यस साता देशभर आंशिक बदली रही केही स्थानमा हल्का वर्षाको सम्भावना।',
        'imageUrl': 'assets/images/news/weather.jpg',
        'date': '2081-01-01',
        'source': 'मौसम विभाग',
      },
    ];
  }
}
