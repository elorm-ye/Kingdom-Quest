import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kingdom_quest/shared/widgets/app_pop_scope.dart';

void main() {
  testWidgets('AppBackButton calls fallbackRoute when context.canPop is false', (tester) async {
    String currentRoute = '/details';

    final router = GoRouter(
      initialLocation: '/details',
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) {
            currentRoute = '/home';
            return const Scaffold(body: Text('Home Page'));
          },
        ),
        GoRoute(
          path: '/details',
          builder: (context, state) {
            currentRoute = '/details';
            return const Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(56),
                child: AppBackButton(fallbackRoute: '/home'),
              ),
              body: Text('Details Page'),
            );
          },
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    expect(find.text('Details Page'), findsOneWidget);
    expect(currentRoute, '/details');

    // Tap the AppBackButton
    await tester.tap(find.byType(AppBackButton));
    await tester.pumpAndSettle();

    // Should have navigated to fallbackRoute /home
    expect(find.text('Home Page'), findsOneWidget);
    expect(currentRoute, '/home');
  });

  testWidgets('AppPopScope navigates to fallbackRoute when context.canPop is false', (tester) async {
    String currentRoute = '/child';

    final router = GoRouter(
      initialLocation: '/child',
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) {
            currentRoute = '/home';
            return const Scaffold(body: Text('Home Page'));
          },
        ),
        GoRoute(
          path: '/child',
          builder: (context, state) {
            currentRoute = '/child';
            return const AppPopScope(
              fallbackRoute: '/home',
              child: Scaffold(
                body: Text('Child Screen'),
              ),
            );
          },
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    expect(find.text('Child Screen'), findsOneWidget);
    expect(currentRoute, '/child');

    // Simulate system back button press
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    // Should have navigated to fallbackRoute /home instead of exiting
    expect(find.text('Home Page'), findsOneWidget);
    expect(currentRoute, '/home');
  });

  testWidgets('AppPopScope pops normally when context.canPop is true', (tester) async {
    String currentRoute = '/home';

    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) {
            currentRoute = '/home';
            return Scaffold(
              body: ElevatedButton(
                onPressed: () => context.push('/child'),
                child: const Text('Go to Child'),
              ),
            );
          },
        ),
        GoRoute(
          path: '/child',
          builder: (context, state) {
            currentRoute = '/child';
            return const AppPopScope(
              fallbackRoute: '/home',
              child: Scaffold(
                body: Text('Child Screen'),
              ),
            );
          },
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    // Push to child
    await tester.tap(find.text('Go to Child'));
    await tester.pumpAndSettle();
    expect(find.text('Child Screen'), findsOneWidget);

    // Simulate system back button
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('Go to Child'), findsOneWidget);
    expect(currentRoute, '/home');
  });
}
