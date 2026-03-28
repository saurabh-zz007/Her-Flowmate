# Contributing to Her-Flowmate 🌸

We're thrilled you're here! Her-Flowmate is a premium, privacy-first companion, and we value contributions that uphold our standards for stability and clinical accuracy.

## 🛠️ Getting Started
1. **Fork & Clone**: Fork the repository and clone it to your local machine.
2. **Environment**: Ensure you're on the latest Flutter **Stable** channel (`flutter upgrade`).
3. **Dependencies**: Run `flutter pub get`.
4. **Run**: Use `flutter run -d chrome` to test Web-specific hit-testing.

## 🧱 Architectural Guardrails
To prevent regressions in the Pregnancy Dashboard (especially MouseTracker crashes on Web), please follow these patterns:

### 1. The Fragment-First Rule
- Never add a `Scaffold` or `SingleChildScrollView` to a dashboard widget.
- Instead, build your component as a **Fragment** that can be injected into the `HomeScreen` sliver list.
- See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for deeper technical rationale.

### 2. Clinical Data Integrity
- All pregnancy logic must be centered on the **Last Menstrual Period (LMP)**.
- Do not add manual "Conception" offsets (e.g., -14 days). Standard medical math is `Today - LMP`.

## 🧪 Quality Control
Before submitting a Pull Request, please ensure:
1. **Formatting**: Run `dart format .` to maintain consistent style.
2. **Analysis**: Run `flutter analyze` to catch potential null-safety or type issues.
3. **Tests**: Run `flutter test` to verify core business logic.

## 🤝 Branching Strategy
- Create descriptive feature branches: `feature/new-milestone` or `fix/calc-offset`.
- Target the `main` branch with your Pull Request.

## 💬 Community & Support
Join our official community channel to discuss features, get help, or just connect with other contributors:
- **Discord**: [Join Her-Flowmate Community](https://discord.gg/aehkEXj8q)

---
Thank you for helping us empower women's health! 🌸
