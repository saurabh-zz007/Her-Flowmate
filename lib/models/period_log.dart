import 'package:hive/hive.dart';

part 'period_log.g.dart';

@HiveType(typeId: 0)
class PeriodLog extends HiveObject {
  @HiveField(0)
  DateTime startDate;

  @HiveField(1)
  int duration;

  PeriodLog({
    required this.startDate,
    required this.duration,
  });
}
