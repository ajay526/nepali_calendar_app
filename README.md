# Hawkeye Patro

A comprehensive Nepali calendar application with multiple features including events, forex rates, radio streaming, and more.

## Features

- 📅 Nepali Calendar with event management
- 🎯 Kundali calculations
- 📰 News feed integration
- 💱 Real-time forex rates
- 📻 Radio streaming
- 👥 Contact management
- 📅 Event and holiday tracking
- 🌐 Bilingual support (Nepali/English)

## Getting Started

### Prerequisites

- Flutter SDK (>=3.1.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- Git

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/hawkeye_patro.git
```

2. Navigate to project directory:
```bash
cd hawkeye_patro
```

3. Install dependencies:
```bash
flutter pub get
```

4. Create a .env file in the root directory with required API keys:
```
NEWS_API_KEY=your_news_api_key
FOREX_API_KEY=your_forex_api_key
```

5. Run the app:
```bash
flutter run
```

### Environment Setup

Create different environment configurations:

- Development: `.env.dev`
- Staging: `.env.staging`
- Production: `.env.prod`

## Architecture

The app follows a service-based architecture with:

- `lib/screens/` - UI screens
- `lib/services/` - Business logic and API calls
- `lib/providers/` - State management
- `lib/utils/` - Utility functions
- `lib/models/` - Data models

## Testing

Run tests using:

```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test
```

## Building for Release

### Android

```bash
flutter build apk --release
```

### iOS

```bash
flutter build ios --release
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Flutter](https://flutter.dev)
- [Nepali Utils](https://pub.dev/packages/nepali_utils)
- All other open-source packages used in this project
