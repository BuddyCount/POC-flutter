# BuddyCount POC

A Flutter proof-of-concept for a shared budget management app. This app allows users to create groups, add expenses, and track balances between members.

## Features

- **Group Management**: Create and manage expense groups
- **Expense Tracking**: Add expenses with name, amount, currency, and date
- **Member Management**: Add/remove group members
- **Balance Calculation**: Automatic calculation of who owes what to whom
- **Multi-Currency Support**: Support for EUR, USD, CHF, and GBP
- **Cross-Platform**: Runs on iOS, Android, Web, and Desktop

## Screenshots

- Home screen showing group overview, member balances, and recent expenses
- Add expense form with validation
- Responsive design for different screen sizes

## Prerequisites

- **Flutter SDK**: Version 3.9.0 or higher
- **Dart SDK**: Version 3.9.0 or higher
- **Platform-specific tools**:
  - **iOS**: Xcode (for iOS development)
  - **Android**: Android Studio with Android SDK
  - **Web**: Chrome browser (for web development)

## Installation

1. **Clone the repository**:
   ```bash
   git clone <your-repository-url>
   cd buddycount_poc
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Verify Flutter setup**:
   ```bash
   flutter doctor
   ```

## Running the App

### Web (Recommended for quick testing)
```bash
flutter run -d chrome
```

### iOS Simulator
```bash
# Launch iOS Simulator
flutter emulators --launch apple_ios_simulator

# Run the app
flutter run -d ios
```

### Android Emulator
```bash
# Launch Android Emulator
flutter emulators --launch <emulator_id>

# Run the app
flutter run -d android
```

### macOS Desktop
```bash
flutter run -d macos
```

## Project Structure

```
lib/
├── main.dart              # App entry point
├── models/                # Data models
│   ├── expense.dart       # Expense model
│   ├── person.dart        # Person model
│   └── group.dart         # Group model
├── providers/             # State management
│   └── group_provider.dart # Group state provider
└── screens/               # UI screens
    ├── home_screen.dart   # Main home screen
    └── add_expense_screen.dart # Add expense form
```

## Dependencies

- **provider**: State management
- **intl**: Internationalization and formatting
- **flutter**: Core Flutter framework

## Development

### Hot Reload
While the app is running, press `r` in the terminal for hot reload.

### Hot Restart
Press `R` in the terminal for hot restart.

### Available Commands
- `h`: Show all available commands
- `q`: Quit the app
- `d`: Detach from the device

## Building for Production

### Web
```bash
flutter build web
```

### iOS
```bash
flutter build ios
```

### Android
```bash
flutter build apk
```

## Troubleshooting

### Common Issues

1. **Dependencies not found**:
   ```bash
   flutter clean
   flutter pub get
   ```

2. **iOS build issues**:
   - Ensure Xcode is installed and up to date
   - Accept Xcode license: `sudo xcodebuild -license accept`
   - Install CocoaPods: `sudo gem install cocoapods`

3. **Android build issues**:
   - Ensure Android SDK is properly configured
   - Accept Android licenses: `flutter doctor --android-licenses`

### Flutter Doctor
Run `flutter doctor` to diagnose any setup issues.

## Contributing

This is a proof-of-concept project. Feel free to fork and modify for your own needs.

## License

This project is for educational/demonstration purposes.
