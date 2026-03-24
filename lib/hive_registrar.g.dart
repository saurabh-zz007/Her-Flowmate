import 'package:hive_ce/hive.dart';
import 'package:her_flowmate/models/period_log.dart';

extension HiveRegistrar on HiveInterface {
  void registerAdapters() {
    registerAdapter(PeriodLogAdapter());
  }
}
