import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Intercepts back navigation (both hardware back button and swipe back gesture).
/// If there is a route to pop, it pops normally.
/// If the route stack is empty, it safely navigates to [fallbackRoute] instead of closing the app.
class AppPopScope extends StatelessWidget {
  final Widget child;
  final String fallbackRoute;
  final VoidCallback? onPop;

  const AppPopScope({
    super.key,
    required this.child,
    this.fallbackRoute = '/home',
    this.onPop,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (onPop != null) {
          onPop!();
          return;
        }
        if (context.canPop()) {
          context.pop();
        } else {
          context.go(fallbackRoute);
        }
      },
      child: child,
    );
  }
}

/// Standardized AppBar leading back button that safely navigates back without throwing GoError.
class AppBackButton extends StatelessWidget {
  final String fallbackRoute;
  final Color? color;
  final VoidCallback? onPressed;

  const AppBackButton({
    super.key,
    this.fallbackRoute = '/home',
    this.color,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, size: 20),
      color: color,
      tooltip: 'Back',
      onPressed: () {
        if (onPressed != null) {
          onPressed!();
          return;
        }
        if (context.canPop()) {
          context.pop();
        } else {
          context.go(fallbackRoute);
        }
      },
    );
  }
}
