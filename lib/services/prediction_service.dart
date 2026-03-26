import 'storage_service.dart';
import '../models/cycle_engine.dart';
export '../models/cycle_engine.dart' show CyclePhase, CyclePhaseX;

class PredictionService {
  final StorageService storageService;

  PredictionService(this.storageService);

  /// Convenience shorthand: the human-readable name of the current phase.
  String get phaseDisplayName => currentPhase.displayName;

  int get averageCycleLength =>
      CycleEngine.calculateAverageCycleLength(storageService.getLogs());

  /// Variance check: if cycle length varies by more than 7 days, it's flagged as irregular.
  bool get isIrregularCycle =>
      CycleEngine.detectIrregularity(storageService.getLogs());

  /// Calculates a simple health score (0-100) based on regularity and track usage.
  int getHealthScore() {
    final logs = storageService.getLogs();
    if (logs.isEmpty) return 0;

    int score = 50; // Base score
    if (!isIrregularCycle) score += 30;
    if (logs.length >= 3) score += 20;

    return score.clamp(0, 100);
  }

  DateTime? get currentPeriodStart {
    final logs = storageService.getLogs();
    return logs.isEmpty ? null : logs.first.startDate;
  }

  DateTime? get nextPeriodDate {
    final start = currentPeriodStart;
    return start?.add(Duration(days: averageCycleLength));
  }

  CyclePhase get currentPhase => getPhaseForDay(DateTime.now());

  int get currentCycleDay => getCycleDay(DateTime.now());

  int getCycleDay(DateTime date) {
    final logs = storageService.getLogs();
    if (logs.isEmpty) return 0;

    // Find the period start associated with this date
    DateTime? periodStart;
    for (final log in logs) {
      if (!date.isBefore(log.startDate)) {
        periodStart = log.startDate;
        break;
      }
    }

    if (periodStart == null) return 0;

    final normDate = DateTime(date.year, date.month, date.day);
    final normStart = DateTime(
      periodStart.year,
      periodStart.month,
      periodStart.day,
    );
    return normDate.difference(normStart).inDays + 1;
  }

  bool isFertileDay(DateTime date) =>
      CycleEngine.getPhaseForDate(
            date,
            storageService.getLogs(),
            averageCycleLength,
          ) ==
          CyclePhase.ovulation ||
      getConceptionChance(date) > 10;

  bool isPeriodDay(DateTime date) {
    final logs = storageService.getLogs();
    final normDate = DateTime(date.year, date.month, date.day);

    for (final log in logs) {
      final start = DateTime(
        log.startDate.year,
        log.startDate.month,
        log.startDate.day,
      );
      DateTime end = log.endDate != null
          ? DateTime(log.endDate!.year, log.endDate!.month, log.endDate!.day)
          : start.add(Duration(days: log.duration - 1));

      if (!normDate.isBefore(start) && !normDate.isAfter(end)) {
        return true;
      }
    }

    // Also check future predicted period
    final next = nextPeriodDate;
    if (next != null) {
      final nextStart = DateTime(next.year, next.month, next.day);
      final nextEnd = nextStart.add(
        const Duration(days: 4),
      ); // Assume 5 days for prediction
      if (!normDate.isBefore(nextStart) && !normDate.isAfter(nextEnd)) {
        return true;
      }
    }

    return false;
  }

  bool isOvulationDay(DateTime date) =>
      CycleEngine.getPhaseForDate(
        date,
        storageService.getLogs(),
        averageCycleLength,
      ) ==
      CyclePhase.ovulation;

  CyclePhase getPhaseForDay(DateTime date) => CycleEngine.getPhaseForDate(
    date,
    storageService.getLogs(),
    averageCycleLength,
  );

  int get daysUntilNextPeriod {
    final next = nextPeriodDate;
    if (next == null) return -1;
    final today = DateTime.now();
    return DateTime(
      next.year,
      next.month,
      next.day,
    ).difference(DateTime(today.year, today.month, today.day)).inDays;
  }

  int get daysUntilOvulation {
    final logs = storageService.getLogs();
    if (logs.isEmpty) return -1;

    final avgLen = averageCycleLength;
    final ovulationDay = avgLen - 14;

    final ovDate = logs.first.startDate.add(Duration(days: ovulationDay));
    final today = DateTime.now();
    final normToday = DateTime(today.year, today.month, today.day);
    final normOv = DateTime(ovDate.year, ovDate.month, ovDate.day);

    int diff = normOv.difference(normToday).inDays;

    // If ovulation already passed this cycle, look at next cycle
    return diff < 0 ? diff + avgLen : diff;
  }

  // ── Hormone Logic ─────────────────────────────────────────────────────────

  /// Calculates simplified hormone levels (0.0 to 1.0) based on cycle day.
  Map<String, double> getHormoneLevels(int cycleDay) =>
      CycleEngine.calculateHormones(cycleDay, averageCycleLength);

  Map<String, String> getHormoneDescriptions(int cycleDay) {
    final levels = getHormoneLevels(cycleDay);
    final estrogen = levels['Estrogen']!;
    final progesterone = levels['Progesterone']!;

    String eStatus = estrogen > 0.7
        ? 'High'
        : (estrogen > 0.4 ? 'Rising' : 'Low');
    String pStatus = progesterone > 0.7
        ? 'Peak'
        : (progesterone > 0.3 ? 'Rising' : 'Low');

    return {'Estrogen': eStatus, 'Progesterone': pStatus};
  }

  Map<String, dynamic> getHormoneFocus(int day) {
    final levels = getHormoneLevels(day);

    // Find Highest
    String highestName = 'Estrogen';
    double highestVal = -1.0;
    // Find Lowest
    String lowestName = 'Progesterone';
    double lowestVal = 2.0;

    levels.forEach((name, val) {
      if (val > highestVal) {
        highestVal = val;
        highestName = name;
      }
      if (val < lowestVal) {
        lowestVal = val;
        lowestName = name;
      }
    });

    final descriptions = {
      'Estrogen': 'Supports bone health and regulates your cycle.',
      'Progesterone': 'Prepares your body for a potential pregnancy.',
      'LH': 'Surges to trigger the release of an egg (ovulation).',
      'FSH': 'Stimulates follicles to grow and prepare for release.',
    };

    final dailyContext = {
      'Estrogen': highestVal > 0.8
          ? 'Peaking now to boost your energy and mood.'
          : 'Lower today, may lead to quieter energy.',
      'Progesterone': highestVal > 0.8
          ? 'Peaking to support the uterine lining.'
          : 'Remaining low as your cycle prepares to reset.',
      'LH': highestVal > 0.8
          ? 'Surging now to trigger ovulation within 24-48h.'
          : 'Stable levels while follicles develop.',
      'FSH': highestVal > 0.5
          ? 'Active now to mature your eggs for the month.'
          : 'Resting after its early cycle work is done.',
    };

    return {
      'highest': {
        'name': highestName,
        'value': highestVal,
        'desc': dailyContext[highestName],
      },
      'lowest': {
        'name': lowestName,
        'value': lowestVal,
        'desc': descriptions[lowestName],
      },
    };
  }

  Map<String, String> getPhaseBiology(int cycleDay) {
    final phase = getPhaseForDay(
      DateTime.now().add(Duration(days: cycleDay - currentCycleDay)),
    );

    switch (phase) {
      case CyclePhase.menstrual:
        return {
          'insight':
              'Your period is occurring. The uterus is shedding its lining because pregnancy did not occur in the previous cycle.',
          'hormoneActivity': 'Low estrogen and progesterone.',
        };
      case CyclePhase.follicular:
        return {
          'insight':
              'Your body is preparing for ovulation. The ovaries are developing follicles, and estrogen levels are gradually increasing.',
          'hormoneActivity': 'Rising estrogen, low progesterone.',
        };
      case CyclePhase.ovulation:
        return {
          'insight':
              'An egg is released from the ovary. This is the most fertile point in the cycle.',
          'hormoneActivity': 'LH surge and peak estrogen levels.',
        };
      case CyclePhase.luteal:
        return {
          'insight':
              'Progesterone increases to support a potential pregnancy. If fertilization does not occur, hormone levels will drop.',
          'hormoneActivity': 'High progesterone, declining estrogen.',
        };
      default: // Handles CyclePhase.unknown
        return {
          'insight': 'Data unavailable for this day.',
          'hormoneActivity': 'Unknown',
        };
    }
  }

  String getConceptionStatus(int chance) =>
      CycleEngine.getConceptionStatus(chance);

  int getConceptionChance(DateTime date) =>
      CycleEngine.calculateConceptionChance(
        date,
        storageService.getLogs(),
        averageCycleLength,
      );

  int get currentConceptionChance => getConceptionChance(DateTime.now());

  String get fertilityLevel {
    final chance = currentConceptionChance;
    return chance >= 25 ? 'High' : (chance >= 10 ? 'Moderate' : 'Low');
  }
}
