# HerFlowmate 🌸
**Your gentle, premium cycle and pregnancy companion built with Flutter.**

[![Flutter Build](https://img.shields.io/badge/Flutter-v3.29.0-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)
[![Deployment](https://img.shields.io/badge/Live-Web%20Demo-ff69b4)](https://hillhack.github.io/Her-Flowmate/)
[![Discord](https://img.shields.io/badge/Discord-Join%20Community-7289DA?logo=discord&logoColor=white)](https://discord.gg/aehkEXj8q)

HerFlowmate is a minimalist, privacy-first health tracker designed to empower women with deep biological insights, clinical-grade pregnancy tracking, and calm, premium aesthetics.

---

---

---

## 🌸 The 3-Phase Journey

HerFlowmate is designed to grow with you, adapting its entire experience to whatever life stage you're in.

### 🍃 Phase I: Period Tracking
*Focus: Understanding Your Body & Health*
- **🔄 The Evolution Wheel**: A beautiful, floral map of your cycle. See at a glance where you are and when your next period is coming.
- **✨ Daily Insights**: Understand how your hormones affect your **Energy** and **Mood** every day, so you can plan your life with confidence.
- **📝 Simple Health Check**: Quickly log how you're feeling, from symptoms to water intake, to discover your own unique health patterns.
- **🩺 Smart Awareness**: The app gently alerts you if your cycle varies, helping you stay informed about your internal health.

### 💖 Phase II: Conceive
*Focus: Finding the Right Time*
- **🎯 Fertility Windows**: Clear, simple predictions of your most fertile days, helping you understand the best time to try for a baby.
- **📈 Understanding Your Chances**: Real-time updates on your conception chances, presented in simple percentages that anyone can understand.
- **⚡ Ovulation Surges**: Easy-to-read markers that highlight your peak moments during the month.

### 🤰 Phase III: Pregnancy
*Focus: Watching Your Baby Grow*
- **🏔️ Milestone Tracking**: A beautiful, glowing progress bar that guides you through every day of your 9-month journey.
- **🍐 Baby Growth**: See how your baby is developing with fun fruit and vegetable size comparisons (like Week 12: Lemon!).
- **🏥 Precise Dating**: We handle the complex math of trimesters and weeks for you, ensuring your due date is always accurate.
- **🌈 Adaptive Design**: The entire app's colors gently shift to match your trimester, creating a calm, supportive space for you.

![Baby Development](file:///home/jyoti/.gemini/antigravity/brain/fd281d84-634b-491b-aae8-4b07d02a9c50/baby_week12_lemon_1774668133157.png)

---

## 🏗️ Technical & Clinical Core

### 📅 Clinical Accuracy (LMP)
HerFlowmate follows strict medical standards for pregnancy tracking:
- **LMP-Based Logic**: All calculations represent the **Last Menstrual Period (LMP)**.
- **280-Day Rule**: Due dates are calculated as `LMP + 280 days`.
- **Accurate Weeks**: Progress is computed as `(Today - LMP) / 7 + 1`.

### 🛡️ Web Stability (Fragment-First)
To ensure a crash-free experience on Flutter Web/Chrome, the app uses a proprietary **Fragment-First Architecture**:
- **Atomic Components**: High-density UI elements are built as standalone, stateless fragments to avoid nested scrollable deadlocks.
- **Nuclear Stability**: Optimized for performance by replacing complex blurs (BackdropFilters) with high-speed linear gradients.

---

## 🛠️ Technological Stack
- **Core**: [Flutter](https://flutter.dev) & [Dart](https://dart.dev)
- **State Management**: [Provider](https://pub.dev/packages/provider)
- **Local Database**: [Hive_ce](https://pub.dev/packages/hive_ce) (Privacy-first encryption)
- **Animations**: [flutter_animate](https://pub.dev/packages/flutter_animate)
- **Styling**: Custom Neumorphic & Glassmorphic design system.

---

## 🚀 Getting Started

1. **Clone & Setup**:
   ```bash
   git clone https://github.com/hillhack/Her-Flowmate.git
   cd Her-Flowmate
   flutter pub get
   ```

2. **Run Locally**:
   ```bash
   flutter run -d chrome
   ```

---

## 💬 Community & Contributing
Join our official [Discord Community](https://discord.gg/aehkEXj8q) to discuss features, get help, or collaborate on the future of women's health.

For contribution guidelines, please see [CONTRIBUTING.md](CONTRIBUTING.md).

---
*HerFlowmate - Understand Your Own Rhythm.*
