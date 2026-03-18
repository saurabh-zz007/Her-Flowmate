import 'storage_service.dart';

enum CyclePhase { menstrual, follicular, ovulation, luteal, unknown }

class PredictionService {
  final StorageService storageService;

  PredictionService(this.storageService);

  int get averageCycleLength {
    final logs = storageService.getLogs();
    if (logs.length < 2) return 28; // Default cycle length

    int totalDays = 0;
    int cycleCount = 0;

    // The logs are orderer newest first.
    for (int i = 0; i < logs.length - 1; i++) {
      final currentStart = logs[i].startDate;
      final previousStart = logs[i+1].startDate;
      
      final cycleDays = currentStart.difference(previousStart).inDays;
      if (cycleDays > 15 && cycleDays < 90) { // Valid duration check
        totalDays += cycleDays;
        cycleCount++;
      }
    }

    if (cycleCount == 0) return 28;
    return (totalDays / cycleCount).round();
  }

  DateTime? get nextPeriodDate {
    final logs = storageService.getLogs();
    if (logs.isEmpty) return null;

    final latestPeriod = logs.first;
    return latestPeriod.startDate.add(Duration(days: averageCycleLength));
  }

  CyclePhase get currentPhase {
    final logs = storageService.getLogs();
    if (logs.isEmpty) return CyclePhase.unknown;

    final latestPeriod = logs.first;
    final today = DateTime.now();
    
    final normToday = DateTime(today.year, today.month, today.day);
    final normStart = DateTime(latestPeriod.startDate.year, latestPeriod.startDate.month, latestPeriod.startDate.day);
    
    final daysSinceStart = normToday.difference(normStart).inDays;
    
    if (daysSinceStart < 0) return CyclePhase.unknown;
    if (daysSinceStart < latestPeriod.duration) return CyclePhase.menstrual;
    
    final cycleLen = averageCycleLength;
    final lutealPhaseLength = 14; 
    final ovulationDay = cycleLen - lutealPhaseLength;
    
    if (daysSinceStart >= cycleLen) return CyclePhase.luteal;
    
    if (daysSinceStart < ovulationDay - 5) {
      return CyclePhase.follicular;
    } else if (daysSinceStart >= ovulationDay - 5 && daysSinceStart <= ovulationDay) {
      return CyclePhase.ovulation;
    } else {
      return CyclePhase.luteal;
    }
  }

  int get currentCycleDay {
    final logs = storageService.getLogs();
    if (logs.isEmpty) return 0;
    final latestPeriod = logs.first;
    final today = DateTime.now();
    final normToday = DateTime(today.year, today.month, today.day);
    final normStart = DateTime(latestPeriod.startDate.year, latestPeriod.startDate.month, latestPeriod.startDate.day);
    return normToday.difference(normStart).inDays + 1;
  }

  bool isFertileDay(DateTime date) {
    final logs = storageService.getLogs();
    if (logs.isEmpty) return false;

    final latestPeriod = logs.first;
    final cycleLen = averageCycleLength;
    final ovulationDay = cycleLen - 14;
    
    // Start 5 days before ovulation
    final fertileStart = latestPeriod.startDate.add(Duration(days: ovulationDay - 5));
    // End on ovulation day
    final fertileEnd = latestPeriod.startDate.add(Duration(days: ovulationDay));
    
    final normDate = DateTime(date.year, date.month, date.day);
    final normStart = DateTime(fertileStart.year, fertileStart.month, fertileStart.day);
    final normEnd = DateTime(fertileEnd.year, fertileEnd.month, fertileEnd.day, 23, 59, 59);
    
    return !normDate.isBefore(normStart) && !normDate.isAfter(normEnd);
  }

  int get daysUntilNextPeriod {
    final nextPeriod = nextPeriodDate;
    if (nextPeriod == null) return -1;
    final today = DateTime.now();
    final normToday = DateTime(today.year, today.month, today.day);
    final normNext = DateTime(nextPeriod.year, nextPeriod.month, nextPeriod.day);
    return normNext.difference(normToday).inDays;
  }
}
