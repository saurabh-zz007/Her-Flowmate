import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import '../services/storage_service.dart';
import '../services/prediction_service.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final storageService = context.watch<StorageService>();
    final predictionService = context.watch<PredictionService>();
    final logs = storageService.getLogs();

    return SafeArea(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Calendar',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Container(width: 8, height: 8, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red)),
                    const SizedBox(width: 4),
                    const Text('Period', style: TextStyle(fontSize: 12)),
                  ],
                ),
                Row(
                  children: [
                    Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.deepPurple.shade300)),
                    const SizedBox(width: 4),
                    const Text('Fertile', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarStyle: const CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.pinkAccent,
                  shape: BoxShape.circle,
                ),
              ),
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  bool isPeriodDay = logs.any((log) {
                    final end = log.startDate.add(Duration(days: log.duration - 1));
                    return !date.isBefore(DateTime(log.startDate.year, log.startDate.month, log.startDate.day)) &&
                           !date.isAfter(DateTime(end.year, end.month, end.day, 23, 59, 59));
                  });

                  bool isFertile = predictionService.isFertileDay(date);

                  List<Widget> markers = [];
                  if (isPeriodDay) {
                    markers.add(Container(
                        width: 8, height: 8, 
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red)));
                  } else if (isFertile) {
                    // Only show fertile dots if it's not a period day
                    markers.add(Container(
                        width: 8, height: 8, 
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.deepPurple.shade300)));
                  }

                  if (markers.isNotEmpty) {
                    return Positioned(
                      bottom: 4,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: markers.map((m) => Padding(padding: const EdgeInsets.symmetric(horizontal: 1), child: m)).toList(),
                      ),
                    );
                  }
                  return null;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
