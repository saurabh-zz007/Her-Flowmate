import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/prediction_service.dart';
import '../utils/app_theme.dart';
import '../widgets/cycle_phase_wheel.dart';
import '../widgets/neu_insight_card.dart';
import 'package:fl_chart/fl_chart.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pred = context.watch<PredictionService>();

    final cycleDay = pred.currentCycleDay == 0 ? 1 : pred.currentCycleDay;
    final cycleLen = pred.averageCycleLength > 0 ? pred.averageCycleLength : 28;
    final phaseName = pred.phaseDisplayName; // DRY: no local switch needed
    final daysToNext = pred.daysUntilNextPeriod;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header
                Text(
                  'Cycle Insights',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 32),

                // Large Phase Wheel
                CyclePhaseWheel(
                  currentCycleDay: cycleDay,
                  cycleLength: cycleLen,
                  currentPhase: phaseName,
                  daysUntilNextPeriod: daysToNext,
                ).animate().fadeIn(duration: 800.ms).scale(curve: Curves.easeOutBack),

                const SizedBox(height: 32),
                const _DailyInsightCard().animate().fadeIn(delay: 400.ms),
                const SizedBox(height: 32),

                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: [
                    NeuInsightCard(
                      title: 'Cycle Length',
                      value: '$cycleLen days',
                      subtitle: 'Average last 6 cycles',
                      icon: Icons.calendar_today_rounded,
                      accentColor: AppTheme.phaseColors['Ovulation']!,
                      onTap: () =>
                          _showSnack(context, 'Your average cycle is $cycleLen days.'),
                    ),
                    NeuInsightCard(
                      title: 'Fertile Window',
                      value: '6 days',
                      subtitle: pred.currentPhase == CyclePhase.ovulation
                          ? 'Peak fertility today'
                          : 'Upcoming',
                      icon: Icons.favorite_rounded,
                      accentColor: AppTheme.accentPink,
                    ),
                    NeuInsightCard(
                      title: 'Symptoms Logged',
                      value: '0',
                      subtitle: 'This cycle',
                      icon: Icons.emoji_emotions_rounded,
                      accentColor: AppTheme.phaseColors['Luteal']!,
                    ),
                    NeuInsightCard(
                      title: 'Regularity',
                      value: '92%',
                      subtitle: 'Very consistent',
                      icon: Icons.trending_up_rounded,
                      accentColor: AppTheme.phaseColors['Ovulation']!,
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Data Visualizations
                _buildSymptomFrequencyChart(),
                const SizedBox(height: 32),
                _buildHeatmap(),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSymptomFrequencyChart() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: AppTheme.glassDecoration(radius: 24, color: Colors.white.withOpacity(0.08)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Symptom Frequency',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textMain),
              ),
              const SizedBox(height: 8),
              Text(
                'Most logged symptoms over the last 3 cycles',
                style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textMuted),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 10,
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (val, meta) {
                            final style = TextStyle(color: AppTheme.textMuted, fontWeight: FontWeight.bold, fontSize: 12);
                            String text = '';
                            switch (val.toInt()) {
                              case 0: text = 'Cramps'; break;
                              case 1: text = 'Fatigue'; break;
                              case 2: text = 'Bloat'; break;
                              case 3: text = 'Acne'; break;
                              case 4: text = 'Mood'; break;
                            }
                            return Padding(padding: const EdgeInsets.only(top: 8.0), child: Text(text, style: style));
                          },
                        ),
                      ),
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    barGroups: [
                      _buildBarGroup(0, 8, AppTheme.accentPink),
                      _buildBarGroup(1, 6, AppTheme.accentPurple),
                      _buildBarGroup(2, 4, AppTheme.accentCyan),
                      _buildBarGroup(3, 3, AppTheme.neonGreen),
                      _buildBarGroup(4, 5, const Color(0xFFFFB74D)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 200.ms).slideY(begin: 0.1);
  }

  BarChartGroupData _buildBarGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 20,
          borderRadius: BorderRadius.circular(6),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 10,
            color: AppTheme.neuShadowLight.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildHeatmap() {
    // Simple UI mock for a calendar heatmap representation
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: AppTheme.neuInnerDecoration(radius: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cramps Intensity',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textMain),
              ),
              const Icon(Icons.show_chart_rounded, color: AppTheme.accentPink),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(14, (index) {
              // Mock intensity based on a fake bell curve
              double intensity = 0;
              if (index > 2 && index < 7) intensity = (index == 4 || index == 5) ? 1.0 : 0.6;
              else if (index == 2 || index == 7) intensity = 0.3;

              return Container(
                width: 14,
                height: 40,
                decoration: BoxDecoration(
                  color: intensity > 0 ? AppTheme.accentPink.withOpacity(intensity) : AppTheme.neuShadowDark.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('2 Weeks Ago', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textMuted)),
              Text('Today', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textMuted)),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 400.ms).slideY(begin: 0.1);
  }

  void _showSnack(BuildContext ctx, String msg) {
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(msg)));
  }
}

class _DailyInsightCard extends StatelessWidget {
  const _DailyInsightCard();

  static const List<String> _tips = [
    "Did you know? Regular exercise can help reduce menstrual cramps by improving blood flow.",
    "Stay hydrated! Drinking water helps reduce bloating during your cycle.",
    "Iron-rich foods like spinach and lentils are great during your menstrual phase.",
    "The follicular phase is often when your energy and creativity are at their peak.",
    "Your body requires more rest during the luteal phase. Listen to it!",
    "Magnesium-rich foods like dark chocolate and bananas can help with PMS symptoms.",
    "Tracking your symptoms helps you identify your own unique cycle patterns over time."
  ];

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    final tip = _tips[dayOfYear % _tips.length];

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: AppTheme.glassDecoration(radius: 28, color: const Color(0xFFFFF3F0).withOpacity(0.4)),
          child: Row(
            children: [
              const Text('💡', style: TextStyle(fontSize: 28)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Daily Insight', 
                      style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.accentPink)),
                    const SizedBox(height: 4),
                    Text(tip, 
                      style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textDark, height: 1.4)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
