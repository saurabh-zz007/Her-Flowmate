# [Her-Flowmate Codebase Audit]

This document summarizes the technical issues, architectural debt, and performance bottlenecks identified during the optimization sprint.

## 🔴 Critical Issues (Resolved/In Progress)

### 1. RenderFlex Overflows (UI Layout)
- **Status**: Fixed in `calendar_screen.dart`, `daily_checkin_screen.dart`, and `main_navigation_screen.dart`.
- **Reason**: Use of height-constrained `NeuContainer` wrappers around long `Column` widgets instead of scrollable views.
- **Recommendation**: Standardize the use of `SingleChildScrollView` within all modal bottom sheets.

### 2. Rendering Performance (Lag/Sluggishness)
- **Status**: Partially Fixed in `AppTheme`, `NeuContainer`, and `HomeScreen`.
- **Reason**: High-cost `BackdropFilter` (Glassmorphism) and large `BoxShadow` blur/spread radii.
- **Recommendation**: Always wrap expensive custom-painted or blurred widgets in `RepaintBoundary`. Continue reducing blur sigma values for Web compatibility.

### 3. Gesture Collisions
- **Status**: Fixed in `MainNavigationScreen`.
- **Reason**: Nested `GestureDetector` widgets (Outer wrapper + internal `NeuContainer` detector) causing unresponsive UI elements.
- **Recommendation**: Avoid wrapping `NeuContainer` or other custom interactive widgets in extra `GestureDetector`s. Use the provided `onTap` property.

## 🟡 Architectural Debt

### 1. Monolithic Screen Files
- **Files**: `home_screen.dart` (~1000 lines before refactor), `calendar_screen.dart` (1010 lines).
- **Issue**: Giant stateful classes containing dozens of private helper methods for building UI sections. This makes testing and maintaining specific parts difficult.
- **Recommendation**: Continue the pattern of extracting dashboards and complex sub-sections into standalone `StatelessWidget` classes to isolate rebuilds and improve readability.

### 2. Service Logic Bloat
- **Files**: `prediction_service.dart` (16K).
- **Issue**: The service handles everything from cycle math and phase naming to UI-specific data formatting.
- **Recommendation**: Extract core cycle calculation logic into a domain model (e.g., `CycleEngine`) to separate business logic from the `ChangeNotifier` state management.

### 3. State Management Overhead
- **Issue**: Heavy reliance on `context.watch<T>()` at the top level of large build methods.
- **Impact**: Any small change in the `PredictionService` triggers a full rebuild of the entire screen tree.
- **Recommendation**: Use `Selector` or scoped `Consumer` widgets to listen only to the specific properties required for a given sub-section.

## 🔵 Technical Debt & Quality

### 1. Flutter 3.41+ Compatibility
- **Issue**: Frequent use of deprecated `withOpacity`.
- **Recommendation**: Migrate to the more performant `withValues(alpha: ...)` for all color manipulations.

### 2. Missing `const` Optimization
- **Issue**: Many static UI elements (Icons, Spacers, Text styles) lack `const` constructors, leading to unnecessary widget object creation during rebuilds.
- **Recommendation**: Enable more aggressive linting for `prefer_const_constructors` and apply project-wide.

### 3. String Hardcoding
- **Issue**: UI strings are hardcoded in the widgets.
- **Recommendation**: Implement `intl` for localization to prepare for multi-language support and centralize copy management.

## 🟢 Environment & Build Issues

### 1. Dart Compiler Crashes
- **Observation**: Recent terminal logs show "The Dart compiler exited unexpectedly."
- **Potential Cause**: Large file sizes or complex generic types in `IndexedStack` or complex `CustomPainter` implementations.
- **Recommendation**: Refactoring the monolithic screens (already started) should mitigate this by reducing the size of individual compilation units.
