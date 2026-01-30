# WI4ED Mobile Application

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![State Management](https://img.shields.io/badge/State--Management-Provider-%230175C2.svg?style=for-the-badge)
![License](https://img.shields.io/badge/license-MIT-green.svg?style=for-the-badge)

**WI4ED** is a state-of-the-art, edge-intelligent mobile application designed for real-time electrical safety monitoring and appliance-health analysis. Built with a "dark-first" philosophy, the app provides homeowners with unparalleled visibility into their electrical infrastructure.

---

## 🚀 Key Features

### 🔌 Intelligent Power Analytics
*   **Real-time Scorecard**: High-precision power consumption monitoring (Watts) with a dynamic, gradient-mapped gauge.
*   **Signature Recognition**: Advanced identification of appliance-specific electrical footprints.
*   **Usage Breakdown**: Granular energy tracking (kWh) across individual devices.

### 📜 Historical Log Explorer (New)
*   **Smart Timeline**: Horizontal calendar strip with support for single-day and custom date range selection.
*   **Historical Insights**: Automatic pattern detection highlighting "12% lower usage" or "High Usage" anomalies.
*   **Appliance Catalog**: Detailed historical list of device performance, health scores, and individual anomaly logs.

### 🛡️ Safety & Anomaly Center
*   **Predictive Health**: Real-time health scoring (0-100%) to preemptive detect appliance failure.
*   **Critical Alerts**: Actionable notifications for inrush growth, sustained overloads, and signature drifts.
*   **Status Indicators**: Glowing high-visibility indicators for "Normal" vs "Anomalous" operating modes.

### 🎨 Premium Aesthetics
*   **OLED Black UI**: True black (#0A0A0A) background for maximum contrast and battery efficiency.
*   **Lime Accent Engine**: Integrated premium lime (#B5FF00) design system with glassmorphic cards.
*   **Micro-animations**: Smooth transitions, radial glows, and animated switcher navigation.

---

## 🛠️ Tech Stack & Architecture

| Component | Technology |
| :--- | :--- |
| **Framework** | Flutter (Dart SDK ^3.10.8) |
| **State Management** | Provider (ChangeNotifier / Consumer) |
| **Visualization** | Custom Painter API & FL Chart |
| **Typography** | Inter & Google Fonts Integration |
| **Localization** | Flutter Intl (Multi-language Support) |

### Layered Architecture
```text
lib/
├── core/           # Design System, Theme Data, Providers
├── data/           # Models, Historical Logging Services, Mock API
├── l10n/           # Multi-language localization bundles
├── presentation/   # UI components
│   ├── navigation/ # Pill-style Bottom Navigation
│   ├── screens/    # Stats, Devices, Alerts, Logs, Settings
│   └── widgets/    # MetricRing, SoftCard, CalendarStrip
└── app.dart        # Internal routing and app configuration
```

---

## 💻 Getting Started

### Prerequisites
*   Flutter SDK (Stable Channel)
*   VS Code / Android Studio with Flutter extensions

### Installation

1.  **Clone the Repo**
    ```bash
    git clone https://github.com/your-username/wi4ed-mobile-app.git
    cd wi4ed-mobile-app
    ```
2.  **Fetch Dependencies**
    ```bash
    flutter pub get
    ```
3.  **Run Application**
    ```bash
    flutter run
    ```

---

## 📄 License

This software is released under the **MIT License**. See the [LICENSE](LICENSE) file for more information.

---
*Developed with focus on Electrical Safety and Premium UX*