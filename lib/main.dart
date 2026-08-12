import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
// import 'dart:html' hide Platform; // Removed to allow native compilation

import 'core/theme/app_theme.dart';
import 'core/services/supabase_service.dart';
import 'features/auth/presentation/controllers/auth_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }

  String supabaseUrl = const String.fromEnvironment('SUPABASE_URL');
  String supabaseAnonKey = const String.fromEnvironment('SUPABASE_ANON_KEY');

  // Also check for user provided NEXT_PUBLIC keys
  if (supabaseUrl.isEmpty) {
    supabaseUrl = const String.fromEnvironment('NEXT_PUBLIC_SUPABASE_URL');
  }
  if (supabaseAnonKey.isEmpty) {
    supabaseAnonKey = const String.fromEnvironment(
      'NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY',
    );
  }

  // Try to get values from environment (for desktop/mobile)
  // Fallback to trying to get from window object (for web)
  if (kIsWeb) {
    // Web specific logic removed to allow cross-platform compilation
    // Meta tags can be accessed via package:web if needed
  } else {
    // For desktop/mobile, use environment variables if still empty
    if (supabaseUrl.isEmpty) {
      supabaseUrl =
          Platform.environment['SUPABASE_URL'] ??
          Platform.environment['NEXT_PUBLIC_SUPABASE_URL'] ??
          '';
    }
    if (supabaseAnonKey.isEmpty) {
      supabaseAnonKey =
          Platform.environment['SUPABASE_ANON_KEY'] ??
          Platform.environment['NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY'] ??
          '';
    }
  }

  // Final fallback to provided keys if environment is not configured
  if (supabaseUrl.isEmpty) {
    supabaseUrl = 'https://qwllshdzcssqetgxmirc.supabase.co';
  }
  if (supabaseAnonKey.isEmpty) {
    supabaseAnonKey = 'sb_publishable_XFFvxculR68Mx4JKTNuEaQ_dnoFjeFB';
  }

  // Initialize Supabase service
  final supabaseService = SupabaseService();
  await supabaseService.initialize(supabaseUrl, supabaseAnonKey);

  runApp(const ProviderScope(child: FrinkelsApp()));
}

class FrinkelsApp extends ConsumerWidget {
  const FrinkelsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch authControllerProvider to ensure it stays alive throughout the app lifecycle.
    // If not watched at the root, it may be disposed when moving between routes
    // (e.g., from Login to Home), causing auth state loss.
    ref.watch(authControllerProvider);

    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'FRINKELs',
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      routerConfig: router,
    );
  }
}
