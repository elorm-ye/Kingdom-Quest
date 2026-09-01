import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// Splash screen with brand mark on solid background.
/// Matches the brand guidelines: vessel mark on solid terracotta.

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
    await Future.delayed(const Duration(milliseconds: 2000));
    if (mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.splashBg,
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
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSection),
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
                        decoration: const BoxDecoration(
                          color: AppColors.splashBg,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Wordmark — "Kingdom Quest"
              Text(
                'Kingdom\nQuest',
                textAlign: TextAlign.center,
                style: textTheme.displayLarge?.copyWith(
                  color: AppColors.linen,
                  height: 1.1,
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Tagline
              Text(
                'A safe, sacred space for young people',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.linen.withValues(alpha: 0.8),
                ),
              ),

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
              ),

              const SizedBox(height: AppSpacing.huge),
            ],
          ),
        ),
      ),
    );
  }
}
