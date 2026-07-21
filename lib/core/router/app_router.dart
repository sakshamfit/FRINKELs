import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';

/// AppRouter configures GoRouter for FRINKELs feature-first routing.
abstract class AppRouter {
  static const String splashPath = '/';
  static const String homePath = '/home';
  static const String authPath = '/auth';

  static final GoRouter router = GoRouter(
    initialLocation: splashPath,
    routes: [
      GoRoute(
        path: splashPath,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: homePath,
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text(
              'Home Screen',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
      ),
      GoRoute(
        path: authPath,
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text(
              'Auth Screen',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
      ),
    ],
  );
}
