import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';
import 'log_period_screen.dart';
import 'daily_checkin_screen.dart';
import 'calendar_screen.dart';
import 'profile_screen.dart';
import '../utils/app_theme.dart';
import '../widgets/neu_container.dart';
import '../widgets/shared_drawer.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = <Widget>[
    HomeScreen(),
    CalendarScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.frameColor,
      drawer: const SharedDrawer(),
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
        child: IndexedStack(index: _selectedIndex, children: _screens),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      decoration: const BoxDecoration(color: Colors.transparent),
      child: NeuContainer(
        height: 72,
        radius: 36,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        style: NeuStyle.convex,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _bottomNavItem(0, Icons.home_rounded, 'Home'),
            _bottomNavItem(1, Icons.calendar_month_rounded, 'Calendar'),
            _logButton(),
            _bottomNavItem(2, Icons.person_rounded, 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _logButton() {
    return NeuContainer(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => _buildAddMenu(context),
        );
      },
      width: 48,
      height: 48,
      radius: 24,
      style: NeuStyle.convex,
      child: const Icon(
        Icons.add_rounded,
        size: 28,
        color: AppTheme.accentPink,
      ),
    );
  }

  Widget _bottomNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: isSelected
            ? BoxDecoration(
                color: AppTheme.accentPink.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              )
            : null,
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.accentPink : AppTheme.textSecondary,
              size: 24,
            ),
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  label,
                  style: GoogleFonts.poppins(
                    color: AppTheme.accentPink,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddMenu(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.frameColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 48,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 20),
            NeuContainer(
              onTap: () {
                Navigator.pop(context);
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const LogPeriodScreen(),
                );
              },
              padding: const EdgeInsets.all(20),
              radius: 24,
              child: Row(
                children: [
                  const Text('🩸', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 16),
                  Text(
                    'Log Period',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                  ),
                ],
              ),
            ).animate().slideY(begin: 0.1, duration: 200.ms),
            const SizedBox(height: 16),
            NeuContainer(
              onTap: () {
                Navigator.pop(context);
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const DailyCheckinScreen(),
                );
              },
              padding: const EdgeInsets.all(20),
              radius: 24,
              child: Row(
                children: [
                  const Text('📝', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 16),
                  Text(
                    'Daily Check-in',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                  ),
                ],
              ),
            ).animate().slideY(begin: 0.1, delay: 100.ms, duration: 200.ms),
          ],
        ),
      ),
    );
  }
}
