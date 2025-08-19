# Country Selector

A Flutter application that allows users to select countries and their respective states through cascading dropdowns, featuring real-time validation, error handling, and a completion flow with result display.

## ⚠️ Architecture

This application follows **Clean Architecture** principles, as close as possible, given the size of application. The architecture uses the **BLoC** pattern for state management, ensuring predictable state changes and excellent testability.

## ⚙️ Installation

Country Selector requires **Flutter SDK 3.8.1** or higher to run. To start setting up your project, clone the repository and navigate into it. Then, install dependencies by executing the following command in your terminal:

```bash
flutter pub get
```

Generate model serialization for JSON handling:

```bash
flutter packages pub run build_runner build
```

Run the application:

```bash
flutter run
```

## 📁 Project Structure

```
lib/
├── core/                    # Core utilities (Dio factory)
├── data/                    # Data layer
│   ├── data_sources/        # External data sources
│   └── repositories/        # Repository implementations
├── models/                  # Data models (Country, State)
├── presentation/            # Presentation layer
│   ├── bloc/               # BLoC state management
│   └── pages/              # UI components and screens
└── main.dart               # App entry point
```

## 🎯 Features

- **Cascading Dropdowns**: State selection depends on country selection
- **Smart Validation**: State dropdown disabled until country is selected
- **Loading Indicators**: Visual feedback during data fetching
- **Error Handling**: Network errors display with retry buttons
- **Shake Animation**: Visual feedback for invalid state selection attempts
- **Reset Functionality**: Clear all selections and reload data
- **Completion Dialog**: Success dialog shows final selections
- **Conditional Buttons**: Complete button only enabled when both selections made
- **Automatic Sorting**: Countries and states sorted alphabetically

## 🧪 Testing

The **CountryCubit** is fully tested with comprehensive coverage including success scenarios, error cases, edge cases, and complete state management flows.

```bash
flutter test
```