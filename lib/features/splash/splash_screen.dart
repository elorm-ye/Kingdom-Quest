import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import 'package:google_fonts/google_fonts.dart';

/// Splash screen with brand mark animation on gradient background.
/// Matches the brand guidelines: vessel mark on terracotta→burnt-amber gradient.

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(milliseconds: 3000));
    if (mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.splashGradient),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 3),

              // The Mark — vessel cupping an offering
              Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.linen.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(
                        AppSpacing.radiusSection,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: AppColors.linen.withValues(alpha: 0.9),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(26),
                            topRight: Radius.circular(26),
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        child: Center(
                          child: Container(
                            width: 20,
                            height: 20,
                            margin: const EdgeInsets.only(bottom: 6),
                            decoration: BoxDecoration(
                              color: AppColors.terracotta,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 800.ms, curve: Curves.easeOut)
                  .scale(
                    begin: const Offset(0.8, 0.8),
                    duration: 800.ms,
                    curve: Curves.easeOut,
                  ),

              const SizedBox(height: AppSpacing.xxl),

              // Wordmark — "Kingdom Quest"
              Text(
                    'Kingdom\nQuest',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.bricolageGrotesque(
                      fontSize: 42,
                      fontWeight: FontWeight.w700,
                      color: AppColors.linen,
                      height: 1.1,
                      letterSpacing: -0.5,
                    ),
                  )
                  .animate(delay: 400.ms)
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: 0.3, duration: 600.ms, curve: Curves.easeOut),

              const SizedBox(height: AppSpacing.lg),

              // Tagline
              Text(
                'A safe, sacred space for young people',
                style: GoogleFonts.schibstedGrotesk(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.linen.withValues(alpha: 0.7),
                  height: 1.4,
                ),
              ).animate(delay: 800.ms).fadeIn(duration: 600.ms),

              const Spacer(flex: 3),

              // Loading indicator
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.linen.withValues(alpha: 0.5),
                  ),
                ),
              ).animate(delay: 1200.ms).fadeIn(duration: 400.ms),

              const SizedBox(height: AppSpacing.huge),
            ],
          ),
        ),
      ),
    );
  }
}
