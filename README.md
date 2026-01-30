# WI4ED Mobile Application

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-green.svg?style=for-the-badge)

**WI4ED** is a premium, edge-intelligent mobile application designed for real-time electrical safety monitoring and appliance-health analysis. Featuring a state-of-the-art dark theme, the app provides homeowners with deep insights into their energy consumption and electrical infrastructure health.

---

## ✨ Features

### 🔌 Edge-Intelligent Monitoring
- **Real-time Power Analytics**: Monitor total power consumption (Watts) with high precision.
- **Appliance Signatures**: Analyze unique electrical signatures to identify specific appliances and their health status.
- **Energy Efficiency Tracking**: Track energy usage (kWh) to identify waste and optimize consumption.

### 🛡️ Electrical Safety & Anomaly Detection
- **Smart Alerts**: Immediate notifications for anomalies like sustained overloads, inrush growth, or signature drifts.
- **Health Scoring**: Predictive appliance health scores (0-100) to preemptively detect failures.
- **Anomaly Banners**: High-visibility alerts for critical electrical events.

### 🎨 Premium Dark UI/UX
- **Modern Aesthetics**: True black background with a vibrant Lime Green (#B5FF00) accent palette.
- **Dynamic Visuals**: 
  - **Semi-circular Power Gauge**: A custom-painted 180° arc with smooth gradients and radial glows.
  - **Pill-style Navigation**: Clean, minimal bottom navigation with micro-animations.
  - **Glassmorphism**: Subtle glass-effect cards and overlays for a premium feel.
- **Optimized Layout**: High-density information presented with generous spacing and modern typography (Inter).

### 🌍 Localization & Accessibility
- **Multi-language Support**: Fully localized for Global audiences.
- **Theme-aware Design**: While optimized for Dark mode, components are built with systemic theme providers.

---

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev) (Dart)
- **State Management**: [Provider](https://pub.dev/packages/provider)
- **Visualization**: [fl_chart](https://pub.dev/packages/fl_chart)
- **Typography**: [Google Fonts (Inter)](https://fonts.google.com/specimen/Inter)
- **Theming**: Systemic Custom Theme Engine

---

## 🏗️ Architecture

The project follows a modular layered architecture to ensure scalability and maintainability:

```text
lib/
├── core/           # Core themes, providers, and shared utilities
├── data/           # Models and services (Mock & API)
├── l10n/           # Localization strings and configurations
├── presentation/   # UI layer (Screens, Widgets, Navigation)
│   ├── screens/    # Feature-specific screens (Home, Auth, Settings, etc.)
│   ├── widgets/    # Reusable custom UI components
│   └── navigation/ # Custom navigation bars and logic
└── app.dart        # Main app configuration
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code with Flutter extension

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/wi4ed-mobile-app.git
   cd wi4ed-mobile-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

---

## 📸 UI Highlights

- **Home Screen**: Features the "Integrated Power Score" gauge with real-time radial pulses and activity tracking.
- **Appliance Details**: Deep-dive analytics for individual devices including historical efficiency.
- **Safety Center**: Managed view of all current anomalies and electrical health status.

---

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---
*Created with ❤️ by the WI4ED Engineering Team*
