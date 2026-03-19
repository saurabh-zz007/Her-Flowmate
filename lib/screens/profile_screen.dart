import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/storage_service.dart';
import '../utils/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = context.watch<StorageService>();
    final initial = storage.userName.isNotEmpty
        ? storage.userName[0].toUpperCase()
        : 'U';

    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            // ── Avatar ───────────────────────────────────────────────────
            ClipRRect(
              borderRadius: BorderRadius.circular(55),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: 110, height: 110,
                  decoration: AppTheme.glassDecoration(
                      radius: 55, color: Colors.white.withOpacity(0.08)),
                  alignment: Alignment.center,
                  child: Text(
                    initial,
                    style: GoogleFonts.poppins(
                        fontSize: 48, fontWeight: FontWeight.bold,
                        color: AppTheme.accentPink),
                  ),
                ),
              ),
            ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),

            const SizedBox(height: 20),
            Text(
              storage.userName.isNotEmpty ? storage.userName : 'Guest',
              style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark),
            ).animate().fadeIn(delay: 200.ms),

            const SizedBox(height: 32),

            // ── Settings Tiles ────────────────────────────────────────────
            _tile(
              context,
              icon: Icons.picture_as_pdf_rounded,
              iconColor: AppTheme.accentPink,
              title: 'Export My Data',
              subtitle: 'Download cycle history as PDF',
              onTap: () async {
                await storage.exportLogsToPdf();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('PDF Export started... check your downloads folder.')));
                }
              },
            ).animate().fadeIn(delay: 400.ms),

            _tile(
              context,
              icon: storage.isMinimalMode
                  ? Icons.motion_photos_paused_rounded
                  : Icons.auto_awesome_rounded,
              iconColor: AppTheme.accentPink,
              title: 'Minimalist Mode',
              subtitle: storage.isMinimalMode ? 'Enabled' : 'Disabled',
              trailing: Switch(
                value: storage.isMinimalMode,
                onChanged: (_) => storage.toggleMinimalMode(),
                activeColor: AppTheme.accentPink,
              ),
              onTap: () => storage.toggleMinimalMode(),
            ).animate().fadeIn(delay: 500.ms),

            _tile(
              context,
              icon: Icons.privacy_tip_rounded,
              iconColor: AppTheme.phaseColors['Ovulation']!,
              title: 'Privacy Policy',
              subtitle: 'Learn how your data is protected',
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Your data is local and encrypted.'))),
            ).animate().fadeIn(delay: 600.ms),

            _tile(
              context,
              icon: Icons.delete_sweep_rounded,
              iconColor: Colors.redAccent,
              title: 'Clear All Data',
              subtitle: 'Permanently erase all logs',
              onTap: () => _confirmDelete(context, storage),
            ).animate().fadeIn(delay: 650.ms),

            const SizedBox(height: 40),

            // ── Logout ────────────────────────────────────────────────────
            if (storage.hasCompletedLogin)
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    decoration: AppTheme.glassDecoration(
                        radius: 20, color: Colors.white.withOpacity(0.05)),
                    child: ElevatedButton.icon(
                      onPressed: () => storage.logout(),
                      icon: const Icon(Icons.logout_rounded, color: AppTheme.accentPink),
                      label: Text('Log Out',
                          style: GoogleFonts.inter(
                              fontSize: 16, fontWeight: FontWeight.w700,
                              color: AppTheme.accentPink)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        minimumSize: const Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 700.ms),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, StorageService storage) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete All Data?'),
        content: const Text('This action cannot be undone. All your period logs and predictions will be cleared.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              storage.deleteAllLogs();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All data cleared.')));
            },
            child: const Text('Delete', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  Widget _tile(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: AppTheme.glassDecoration(
                  radius: 24, color: Colors.white.withOpacity(0.05)),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, color: iconColor, size: 24),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textDark)),
                        if (subtitle != null)
                          Text(subtitle,
                              style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: AppTheme.textDark.withOpacity(0.6))),
                      ],
                    ),
                  ),
                  trailing ??
                      const Icon(Icons.chevron_right_rounded,
                          color: AppTheme.textDark, size: 22),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
