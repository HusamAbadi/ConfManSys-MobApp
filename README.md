# Conference Management System

A Flutter-based mobile application for managing academic conferences, sessions, and presentations.

## Prerequisites

- Flutter SDK (version 3.0.0 or higher)
- Dart SDK (version 2.17.0 or higher)
- Android Studio / VS Code with Flutter extensions
- Git
- A physical device or emulator for testing

## Getting Started

### 1. Clone the Repository

```
git clone https://github.com/HusamAbadi/ConfManSys-MobApp
cd conference_management_system
```

### 2. Install Dependencies

```
flutter pub get
```

### 3. Run the Application

Make sure you have a device connected or an emulator running, then:

```
flutter run
```

## Project Structure

```
conference_management_system/
├── lib/                    # Source code
│   ├── screens/           # UI screens
│   ├── models/            # Data models
│   ├── services/          # Business logic and services
│   └── widgets/           # Reusable widgets
├── assets/                # Images, fonts, and other static files
└── test/                  # Unit and widget tests
```

## Features

- Conference session management
- User authentication
- Schedule viewing and management
- Presentation tracking
- Real-time updates
- User profile management

## Development

### Running Tests

```
flutter test
```

### Building for Production

#### Android
```
flutter build apk --release
```

#### iOS
```
flutter build ios --release
```

## Troubleshooting

Common issues and their solutions:

1. **Build Failures**
   - Clean the project: `flutter clean`
   - Get dependencies again: `flutter pub get`

2. **Emulator Issues**
   - Ensure Android Studio/XCode is up to date
   - Check if the emulator is properly configured

## Contributing

1. Fork the repository
2. Create a new branch
3. Make your changes
4. Submit a pull request

## Appendix

### A. Version History

- v1.0.0 (2025-01-07) - Initial release
  - Basic conference management features
  - User authentication
  - Session management

### B. Dependencies

Key dependencies used in this project:
- flutter_bloc: State management
- firebase_core: Firebase integration
- cloud_firestore: Database operations
- shared_preferences: Local storage

### C. Environment Setup Tips

1. **Flutter Installation**
   - Download Flutter SDK
   - Add Flutter to system PATH
   - Run `flutter doctor` to verify installation

2. **IDE Setup**
   - Install Flutter and Dart plugins
   - Configure editor formatting
   - Set up debugging configurations

### D. Coding Standards

- Follow Flutter's style guide
- Use meaningful variable and function names
- Comment complex logic
- Write unit tests for new features

---
Last updated: 2025-01-07
