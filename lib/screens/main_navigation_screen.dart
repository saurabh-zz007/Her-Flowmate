import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/storage_service.dart';
import '../utils/app_theme.dart';
import 'home_screen.dart';
import 'insights_screen.dart';
import 'log_period_screen.dart';
import 'calendar_screen.dart';
import 'feedback_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';
import 'mode_settings_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = <Widget>[
    HomeScreen(),
    InsightsScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    debugPrint('BUILDING MainNavigationScreen...');
    final storage = context.watch<StorageService>();

    return Scaffold(
      extendBody: true,
      drawer: _buildDrawer(context, storage),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.textDark, size: 28),
        centerTitle: true,
        title: Text(
          'HerFlowmate',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppTheme.textDark,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _onItemTapped(3), // Navigate to Profile
            icon: CircleAvatar(
              radius: 14,
              backgroundColor: AppTheme.accentPink.withOpacity(0.1),
              child: Text(
                storage.userName.isNotEmpty ? storage.userName[0].toUpperCase() : 'U',
                style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.accentPink),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
        child: _screens[_selectedIndex],
      ),
      floatingActionButton: _selectedIndex == 0
          ? Animate(
              effects: const [
                ScaleEffect(
                  begin: Offset(0.9, 0.9),
                  end: Offset(1.0, 1.0),
                  curve: Curves.easeOutBack,
                  duration: Duration(milliseconds: 800),
                ),
              ],
              child: FloatingActionButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => LogPeriodScreen(),
                  );
                },
                backgroundColor: Colors.transparent,
                elevation: 0,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: AppTheme.neuDecoration(
                      radius: 30, color: AppTheme.frameColor),
                  child: const Icon(Icons.water_drop_rounded,
                      size: 28, color: AppTheme.accentPink),
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildDrawer(BuildContext context, StorageService storage) {
    final initial =
        storage.userName.isNotEmpty ? storage.userName[0].toUpperCase() : 'U';

    return Drawer(
      backgroundColor: AppTheme.frameColor,
      elevation: 16,
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: AppTheme.neuDecoration(
                        radius: 28, color: AppTheme.frameColor),
                    child: Center(
                      child: Text(
                        initial,
                        style: GoogleFonts.poppins(
                          color: AppTheme.accentPink,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'HerFlowmate',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Primary Dash
            _drawerItem(icon: Icons.home_rounded, title: 'Dashboard', index: 0),

            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Container(
                  height: 2, decoration: AppTheme.neuInnerDecoration(radius: 1)),
            ),

            // Spec 1 Sidebar Items
            _actionDrawerItem(
                icon: Icons.calendar_month_rounded,
                title: 'Calendar',
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CalendarScreen()));
                }),
            _drawerItem(
                icon: Icons.lightbulb_rounded, title: 'Cycle Insights', index: 1),
            _actionDrawerItem(
                icon: Icons.tune_rounded,
                title: 'Mode Settings',
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ModeSettingsScreen()));
                }),

            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Container(
                  height: 2, decoration: AppTheme.neuInnerDecoration(radius: 1)),
            ),

            _actionDrawerItem(
                icon: Icons.feedback_rounded,
                title: 'Feedback',
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FeedbackScreen()));
                }),
            _actionDrawerItem(
                icon: Icons.settings_rounded, title: 'Settings', onTap: () {}),
            _actionDrawerItem(
                icon: Icons.info_outline_rounded,
                title: 'Help / About',
                onTap: () {}),
            _actionDrawerItem(
                icon: Icons.contact_support_rounded,
                title: 'Contact Support',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Contact us at: herflowmate.app@gmail.com')));
                }),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(36),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          height: 72,
          decoration: AppTheme.glassDecoration(radius: 36, color: Colors.white.withOpacity(0.1)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(0, Icons.grid_view_rounded, 'Home'),
              _navItem(1, Icons.analytics_rounded, 'Insights'),
              const SizedBox(width: 48), // Space for FAB
              _navItem(2, Icons.history_rounded, 'History'),
              _navItem(3, Icons.person_rounded, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: 300.ms,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: isSelected
            ? AppTheme.neuInnerDecoration(radius: 20)
            : const BoxDecoration(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.accentPink : AppTheme.textDark.withOpacity(0.5),
              size: 22,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppTheme.accentPink : AppTheme.textDark.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionDrawerItem(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: Container(
        decoration:
            AppTheme.neuDecoration(radius: 12, color: AppTheme.frameColor),
        child: ListTile(
          leading: Icon(icon, color: AppTheme.accentPink, size: 22),
          title: Text(title,
              style: GoogleFonts.inter(
                  color: AppTheme.textDark,
                  fontSize: 15,
                  fontWeight: FontWeight.w600)),
          onTap: () {
            Navigator.pop(context); // Close drawer
            onTap();
          },
        ),
      ),
    );
  }

  Widget _drawerItem(
      {required IconData icon, required String title, required int index}) {
    final isSelected = _selectedIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: Container(
        decoration: isSelected
            ? AppTheme.neuInnerDecoration(radius: 12)
            : AppTheme.neuDecoration(radius: 12, color: AppTheme.frameColor),
        child: ListTile(
          leading: Icon(icon,
              color: isSelected ? AppTheme.accentPink : AppTheme.textDark.withOpacity(0.5)),
          title: Text(
            title,
            style: GoogleFonts.inter(
              color: isSelected ? AppTheme.accentPink : AppTheme.textDark,
              fontSize: 15,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
          onTap: () {
            _onItemTapped(index);
            Navigator.pop(context); // Close the drawer
          },
        ),
      ),
    );
  }
}
