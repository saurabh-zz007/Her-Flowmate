import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/prediction_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _getPhaseName(CyclePhase phase) {
    switch (phase) {
      case CyclePhase.menstrual:
        return 'Menstrual';
      case CyclePhase.follicular:
        return 'Follicular';
      case CyclePhase.ovulation:
        return 'Ovulation';
      case CyclePhase.luteal:
        return 'Luteal';
      case CyclePhase.unknown:
        return 'Unknown';
    }
  }

  Color _getPhaseColor(CyclePhase phase) {
    switch (phase) {
      case CyclePhase.menstrual:
        return Colors.red.shade400;
      case CyclePhase.follicular:
        return Colors.pink.shade300;
      case CyclePhase.ovulation:
        return Colors.deepPurple.shade300;
      case CyclePhase.luteal:
        return Colors.orange.shade300;
      case CyclePhase.unknown:
        return Colors.grey.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
    final predictionService = context.watch<PredictionService>();
    final currentPhase = predictionService.currentPhase;
    final daysUntilNext = predictionService.daysUntilNextPeriod;
    final currentDay = predictionService.currentCycleDay;
    final avgCycleLen = predictionService.averageCycleLength;
    
    final phaseName = _getPhaseName(currentPhase);
    final phaseColor = _getPhaseColor(currentPhase);
    
    // Calculate progress as a fraction of the current cycle
    final progress = avgCycleLen > 0 ? (currentDay / avgCycleLen).clamp(0.0, 1.0) : 0.0;

    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (currentPhase != CyclePhase.unknown) ...[
                // Circular Progress Phase Indicator
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 250,
                      height: 250,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 16,
                        backgroundColor: Colors.grey.shade200,
                        color: phaseColor,
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Day $currentDay',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          phaseName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: phaseColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 48),
                Text(
                  'You are in the $phaseName phase',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Text(
                  daysUntilNext >= 0 
                    ? '• Next period in $daysUntilNext days'
                    : '• Your period is late by ${daysUntilNext.abs()} days',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ] else ...[
                const Icon(Icons.water_drop_outlined, size: 80, color: Colors.pink),
                const SizedBox(height: 24),
                const Text(
                  'Welcome to Her-Flowmate',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Log your previous period using the + button to see your phase and predictions.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
