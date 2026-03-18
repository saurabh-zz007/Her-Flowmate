# Her-Flowmate

Her-Flowmate is a beautifully designed, privacy-focused menstrual cycle tracking app built with Flutter.

## Features
- **Log Periods**: Easily log the start date and duration of your periods.
- **Phase Prediction**: Displays your current cycle phase (Menstrual, Follicular, Ovulation, Luteal) in a beautiful circular progress indicator.
- **Next Period Prediction**: Calculates your average cycle length to accurately predict when your next period will arrive.
- **Fertile Window Calculation**: Identifies your fertile window (5 days around ovulation) to help you understand your body.
- **Calendar View**: A clean calendar interface with markers indicating past periods (red) and predicted fertile windows (purple).
- **Privacy First**: All data is stored locally on your device using Hive. No data is sent to the cloud.

## Tech Stack
- **Framework**: Flutter (Android & iOS)
- **Local Storage**: Hive (`hive`, `hive_flutter`)
- **State Management**: Provider
- **UI Components**: `table_calendar`, `intl`

## Setup Instructions

1. **Install Flutter**: Make sure you have the Flutter SDK installed on your machine.
2. **Clone the repository**:
   ```bash
   git clone <your-repo-url>
   cd Her-Flowmate
   ```
3. **Install Dependencies**:
   ```bash
   flutter pub get
   ```
4. **Generate Hive Code** (Required only if modifying `PeriodLog` model):
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
5. **Run the App**:
   ```bash
   flutter run
   ```

## Testing the Application

To test the cycle tracking and predictions manually:
1. Launch the app and tap the `+` button in the center.
2. **Log past periods**: Log a period for today, and then log a couple of periods from the past (e.g., 28 days ago, 56 days ago).
3. **Verify Home Screen**: Observe the "Average Cycle" calculated and the days countdown to your next expected period. Also, check the phase progress circle.
4. **Verify Calendar Screen**: Navigate to the calendar tab and verify that the red dots (periods) and purple dots (fertile windows) appear correctly on the timeline.
