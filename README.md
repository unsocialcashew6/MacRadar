#  MacRadar

A lightweight, high-performance native macOS system monitoring tool that lives entirely in your Menu Bar and offers an interactive desktop widget. Built from scratch using **Swift and SwiftUI**.

<p align="center">
  <img src="https://img.shields.io/badge/Platform-macOS-000000?style=flat&logo=apple" alt="Platform: macOS">
  <img src="https://img.shields.io/badge/macOS-Sonoma%20Required-005A9C?style=flat" alt="macOS Sonoma Required">
  <img src="https://img.shields.io/badge/Architecture-Universal-orange?style=flat">
  <img src="https://img.shields.io/badge/License-MIT-yellow?style=flat" alt="License: MIT">
</p>

---

## ✨ Features

- **Live CPU Tracker:** Real-time processor workload calculations powered directly by native macOS `host_statistics`.
- **RAM Monitor:** Dynamic tracking of Active, Wired, and Compressed memory values via 64-bit kernel diagnostics (`host_statistics64`).
- **Storage Metrics:** Accurate representation of available and total disk capacity utilizing `FileManager` system attributes.
- **Smart Adaptive UI:** Embedded horizontal `ProgressView` bars that smoothly shift colors (Blue ➔ Orange ➔ Red) to alert you as hardware load increases.
- **Launch at Login:** Zero-configuration system startup management integrated cleanly with the modern `SMAppService` framework.
- **Medium Desktop Widget:** A beautifully styled desktop element synchronized seamlessly every second with the core application via App Groups.

---

## 📥 Installation

1. Navigate to the **[Releases](https://github.com/unsocialcashew6/)** page of this repository.
2. Download the latest compiled `MacRadar.dmg` installer package.
3. Open the `.dmg` file and drag the **MacRadar** application icon into your Mac's **Applications** folder.
4. Launch the app from your Applications directory.
5. To configure the desktop dashboard: Right-click anywhere on your desktop ➔ select `Edit Widgets...` ➔ search for **MacRadar** ➔ drag the medium layout onto your screen.

---

## ⚠️ Important Note: Fixing the "App is Damaged" Error (Gatekeeper)

Because this utility is a free, self-compiled open-source software project, it is **not signed with a paid Apple Developer Certificate**. When launching it for the first time on a fresh machine, macOS Gatekeeper may block the app and display an alert claiming it is *"damaged"* or from an *"unidentified developer"*.

To resolve this issue and run the application safely, simply remove the internet quarantine flag by opening your **Terminal** app and running the following single command:

```bash
xattr -cr /Applications/MacRadar.app
```

Alternatively, you can manually authorize the application by navigating to **System Settings ➔ Privacy & Security**, scrolling down to the *Security* section, and clicking the **Open Anyway** button after your first launch attempt.

---

## 🛠️ System Requirements

- **Operating System:** macOS 14.0 (Sonoma), macOS 15.0 (Sequoia), or newer.
- **Hardware Architecture:** Fully Universal Binary running natively on Apple Silicon (M1/M2/M3/M4) chips and legacy Intel Core processors.

---

## 🤝 Contributing

Contributions, bug tracking issues, and architectural feature requests are highly welcome! Feel free to review open problems or initiate a new Pull Request.

---

## 📜 License

This project is open-source and distributed under the terms of the **MIT License**. Feel free to use, modify, and share!

---

## ☕ Support the Project

If you find **MacRadar** useful and want to support its further development, you can buy the developer a coffee or send a donation! Any support is highly appreciated.

- **Crypto (USDT TRC20):** `TCvyqhMS8FQkyX7xbm4jRr6kBz9YJAJWbn`
