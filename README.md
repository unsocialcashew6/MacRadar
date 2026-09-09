#  MacRadar — Native macOS System Monitor & Menu Bar Widget

[![Platform: macOS](https://img.shields.io/badge/Platform-macOS-000000?style=flat&logo=apple)](https://github.com/unsocialcashew6/)
[![macOS Sonoma & Sequoia](https://img.shields.io/badge/macOS-14.0%2B%20Sonoma%20%7C%2015.0%2B%20Sequoia-005A9C?style=flat&logo=apple)](https://github.com/unsocialcashew6/)
[![Architecture: Universal](https://img.shields.io/badge/Architecture-Apple%20Silicon%20%7C%20Intel-orange?style=flat)](https://github.com/unsocialcashew6/)
[![Built With: Swift & SwiftUI](https://img.shields.io/badge/Built%20With-Swift%20%26%20SwiftUI-F05138?style=flat&logo=swift)](https://github.com/unsocialcashew6/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow?style=flat)](LICENSE)

A lightweight, high-performance native macOS system monitoring tool designed as an open-source, battery-friendly alternative to iStat Menus and Activity Monitor. **MacRadar** lives directly in your Menu Bar and offers an interactive desktop widget for tracking real-time hardware metrics with zero analytics and minimal CPU overhead. Built from scratch with **Swift and SwiftUI**.

---

## ✨ Key Features

- **Real-Time CPU Usage Tracker:** Real-time processor workload calculations powered directly by native Darwin kernel APIs (`host_statistics`).
- **RAM & Memory Pressure Monitor:** Dynamic tracking of Active, Wired, Compressed, and Free memory via 64-bit kernel diagnostics (`host_statistics64`).
- **Storage Metrics & SSD Capacity:** Accurate representation of available and total disk capacity utilizing `FileManager` system attributes.
- **Smart Adaptive UI:** Embedded horizontal `ProgressView` bars that smoothly shift colors (Blue ➔ Orange ➔ Red) to alert you as hardware load increases.
- **Sonoma & Sequoia Desktop Widget:** A beautifully styled medium-format WidgetKit desktop element synchronized seamlessly every second with the core application via App Groups.
- **Launch at Login:** Zero-configuration system startup management integrated cleanly with Apple's modern `SMAppService` framework.
- **Apple Silicon & Intel Universal Binary:** Compiled for optimal energy efficiency on Apple Silicon (M1/M2/M3/M4) chips and legacy Intel Core processors.

---

## 🆚 Why MacRadar?

| Feature | MacRadar | Traditional Monitor Apps | Activity Monitor |
| :--- | :--- | :--- | :--- |
| **Resource Overhead** | Extremely Low (~0.1% CPU) | Moderate to High | High |
| **Menu Bar Telemetry** | Native SwiftUI | Often Electron / WebTech | Dock icon only |
| **Desktop Widgets** | Native WidgetKit | Rare / Paid feature | None |
| **Privacy & Telemetry** | 100% Offline / Zero Analytics | Cloud syncing / Trackers | Apple Analytics |
| **Pricing** | 100% Free & Open Source | Subscription / Paid License | Built-in |

---

## 📥 Installation

### Option 1: Direct Download (DMG)

1. Navigate to the **[Releases](https://github.com/unsocialcashew6/MacRadar/releases)** page of this repository.
2. Download the latest compiled `MacRadar.dmg` installer package.
3. Open the `.dmg` file and drag the **MacRadar** application icon into your Mac's **Applications** folder.
4. Launch the app from your Applications directory.

### Option 2: Add the Desktop Widget

1. Right-click anywhere on your desktop wallpaper and select **Edit Widgets...**
2. Search for **MacRadar** in the Widget Gallery.
3. Drag the medium layout onto your screen.

---

## ⚠️ Gatekeeper Note: Fixing "App is Damaged" or "Unidentified Developer"

Because this utility is a free, self-compiled open-source software project distributed independently without a paid Apple Developer certificate, macOS Gatekeeper may block the app on first launch and claim it is *"damaged"* or from an *"unidentified developer"*.

To remove the internet quarantine flag and run the application safely, open your **Terminal** and run:

```bash
xattr -cr /Applications/MacRadar.app
```

Alternatively, you can authorize it manually via **System Settings ➔ Privacy & Security**, scrolling down to the *Security* section, and clicking **Open Anyway**.

---

## 🛠️ System Requirements & Tech Stack

- **Operating System:** macOS 14.0 (Sonoma), macOS 15.0 (Sequoia), or newer.
- **Architecture:** Universal Binary (`arm64` Apple Silicon M1/M2/M3/M4 & `x86_64` Intel Core).
- **Frameworks:** Swift 5.9+, SwiftUI, WidgetKit, AppKit, Darwin Kernel APIs, SMAppService.

---

## 🤝 Contributing

Contributions, issue reports, and architectural feature requests are highly welcome! Feel free to review open problems or submit a Pull Request.

---

## 📜 License

This project is open-source and distributed under the terms of the **MIT License**. See `LICENSE` for details.

---

## ☕ Support the Project

If you find **MacRadar** useful and want to support its ongoing development:

- **Crypto (USDT TRC20):** `TCvyqhMS8FQkyX7xbm4jRr6kBz9YJAJWbn`
