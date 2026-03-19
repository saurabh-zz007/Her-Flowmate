import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/storage_service.dart';
import '../utils/app_theme.dart';
import 'main_navigation_screen.dart';

class OnboardingScreen extends StatefulWidget {
  final bool isEmailUser;
  final String prefillName; // auto-filled from Google profile

  const OnboardingScreen({
    super.key,
    this.isEmailUser = false,
    this.prefillName = '',
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  late final TextEditingController _nameController;
  final TextEditingController _ageController = TextEditingController();

  int _currentPage = 0;
  static const int _totalPages = 2; // Info → Privacy

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.prefillName);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage == 0 && _nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name to continue.')),
      );
      return;
    }
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(duration: 350.ms, curve: Curves.easeInOut);
    } else {
      _finish();
    }
  }

  void _back() {
    if (_currentPage > 0) {
      _pageController.previousPage(duration: 300.ms, curve: Curves.easeInOut);
    }
  }

  Future<void> _finish() async {
    final age = int.tryParse(_ageController.text.trim());
    await context.read<StorageService>().completeOnboarding(
      context.read<StorageService>().userGoal,
      _nameController.text.trim(),
      age: age,
    );
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
        (_) => false, // clear the entire back stack
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
        child: SafeArea(
            child: Column(
              children: [
                // ── Top bar ──────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    children: [
                        GestureDetector(
                          onTap: _currentPage > 0 ? _back : () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: AppTheme.neuDecoration(
                                radius: 14, color: AppTheme.frameColor),
                            child: const Icon(Icons.arrow_back_rounded,
                                color: AppTheme.textDark, size: 20),
                          ),
                        ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Step ${_currentPage + 1} of $_totalPages',
                              style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textDark.withOpacity(0.6)),
                            ),
                            const SizedBox(height: 8),
                            _ProgressBar(current: _currentPage, total: _totalPages),
                          ],
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),

                // ── Pages ────────────────────────────────────────────
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (i) => setState(() => _currentPage = i),
                    children: [
                      _infoPage(),
                      _privacyPage(),
                    ],
                  ),
                ),

                // ── Continue / Finish button ──────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Container(
                    decoration: AppTheme.neuDecoration(
                        radius: 18, color: AppTheme.frameColor),
                    child: ElevatedButton.icon(
                      icon: Icon(
                        _currentPage == _totalPages - 1
                            ? Icons.check_rounded
                            : Icons.arrow_forward_rounded,
                        color: AppTheme.accentPink,
                      ),
                      label: Text(
                        _currentPage == _totalPages - 1 ? 'Get Started' : 'Continue →',
                        style: GoogleFonts.inter(
                            fontSize: 17, fontWeight: FontWeight.w700,
                            color: AppTheme.accentPink),
                      ),
                      onPressed: _next,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        disabledForegroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                      ),
                    ),
                  ),
                ),
              ],
          ),
        ),
      ),
    );
  }



  // ── Page 2: Basic Info ──────────────────────────────────────────────────
  Widget _infoPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: AppTheme.neuDecoration(
                radius: 24, color: AppTheme.frameColor),
            child: const Icon(Icons.person_outline_rounded,
                color: AppTheme.accentPink, size: 44),
          ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 28),
          Text(
            "Tell us about yourself",
            style: GoogleFonts.poppins(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
          const SizedBox(height: 10),
          Text(
            "This helps us personalize your cycle context.",
            style: GoogleFonts.inter(
                fontSize: 16,
                color: AppTheme.textDark.withOpacity(0.6),
                height: 1.4),
          ).animate().fadeIn(delay: 350.ms),
          
          const SizedBox(height: 32),
          
          // Name Input
          Text("WHAT SHOULD WE CALL YOU?",
              style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textDark.withOpacity(0.5),
                  letterSpacing: 1)),
          const SizedBox(height: 12),
          Container(
            decoration: AppTheme.neuInnerDecoration(radius: 16),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: TextField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              style: GoogleFonts.inter(
                  fontSize: 18,
                  color: AppTheme.textDark,
                  fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Your name',
                hintStyle: GoogleFonts.inter(
                    color: AppTheme.textDark.withOpacity(0.35)),
              ),
            ),
          ).animate().fadeIn(delay: 480.ms),

          const SizedBox(height: 24),

          // Age Input
          Text("HOW OLD ARE YOU?",
              style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textDark.withOpacity(0.5),
                  letterSpacing: 1)),
          const SizedBox(height: 12),
          Container(
            decoration: AppTheme.neuInnerDecoration(radius: 16),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              style: GoogleFonts.inter(
                  fontSize: 18,
                  color: AppTheme.textDark,
                  fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Age (e.g. 26) - optional',
                hintStyle: GoogleFonts.inter(
                    color: AppTheme.textDark.withOpacity(0.35)),
              ),
            ),
          ).animate().fadeIn(delay: 600.ms),
        ],
      ),
    );
  }

  // ── Page 4: Privacy ─────────────────────────────────────────────────────
  Widget _privacyPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: AppTheme.neuDecoration(
                radius: 50, color: AppTheme.frameColor),
            child: Icon(
              widget.isEmailUser
                  ? Icons.cloud_done_rounded
                  : Icons.shield_rounded,
              color: AppTheme.accentPink,
              size: 64,
            ),
          ).animate().scale(curve: Curves.easeOutBack, duration: 700.ms),
          const SizedBox(height: 32),
          Text(
            widget.isEmailUser
                ? "Data Backed Up"
                : "Privacy Protected",
            style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(22),
            decoration: AppTheme.neuInnerDecoration(radius: 22),
            child: Text(
              widget.isEmailUser
                  ? "Your cycle data is securely linked to your Google account. Log in again on any device to restore all your history."
                  : "All data stays on this device only. Uninstalling or switching phones will erase your history.",
              style: GoogleFonts.inter(
                  fontSize: 15,
                  color: AppTheme.textDark.withOpacity(0.6),
                  height: 1.6),
              textAlign: TextAlign.center,
            ),
          ).animate().fadeIn(delay: 350.ms).slideY(begin: 0.1),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: AppTheme.neuInnerDecoration(radius: 14),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded,
                    color: AppTheme.textDark, size: 16),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Predictions are for information only and are not medical advice.",
                    style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppTheme.textDark.withOpacity(0.6),
                        height: 1.4),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 550.ms),
        ],
      ),
    );
  }
}


// ── Progress Bar ─────────────────────────────────────────────────────────────

class _ProgressBar extends StatelessWidget {
  final int current, total;
  const _ProgressBar({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6,
      decoration: AppTheme.neuInnerDecoration(radius: 3),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: (current + 1) / total,
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.accentPink,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }
}
