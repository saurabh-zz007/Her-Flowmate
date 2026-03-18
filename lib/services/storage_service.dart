import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/period_log.dart';

class StorageService extends ChangeNotifier {
  static const String boxName = 'period_logs';

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(PeriodLogAdapter());
    await Hive.openBox<PeriodLog>(boxName);
  }

  Box<PeriodLog> get _box => Hive.box<PeriodLog>(boxName);

  Future<void> saveLog(PeriodLog log) async {
    await _box.add(log);
    notifyListeners();
  }

  Future<void> deleteLog(int index) async {
    await _box.deleteAt(index);
    notifyListeners();
  }

  Future<void> clearLogs() async {
    await _box.clear();
    notifyListeners();
  }

  List<PeriodLog> getLogs() {
    final logs = _box.values.toList();
    logs.sort((a, b) => b.startDate.compareTo(a.startDate)); // newest first
    return logs;
  }
}
