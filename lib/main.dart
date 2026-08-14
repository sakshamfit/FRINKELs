import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:sentry/sentry.dart';
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
      options: FirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }

  String clerkPublishableKey = const String.fromEnvironment('CLERK_PUBLISHABLE_KEY');
  // Also check for user provided NEXT_PUBLIC keys
  if (clerkPublishableKey.isEmpty) {
    clerkPublishableKey = const String.fromEnvironment('NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY');
  }
  // Try to get values from environment (for desktop/mobile)
  // Fallback to trying to get from window object (for web)
  if (kIsWeb) {
    // Web specific logic removed to allow cross-platform compilation
    // Meta tags can be accessed via package:web if needed
  } else {
    // For desktop/mobile, use environment variables if still empty
    if (clerkPublishableKey.isEmpty) {
      clerkPublishableKey = Platform.environment['CLERK_PUBLISHABLE_KEY'] ??
                          Platform.environment['NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY'] ?? '';
    }
  }

  // Final fallback to provided keys if environment is not configured
  if (clerkPublishableKey.isEmpty) {
    clerkPublishableKey = 'pk_test_...'; // Placeholder, user must replace with actual key
  }

  // Initialize Clerk
  await Clerk.initialize(clerkPublishableKey);

  String supabaseUrl = const String.fromEnvironment('SUPABASE_URL');
  String supabaseAnonKey = const String.fromEnvironment('SUPABASE_ANON_KEY');

  // Also check for user provided NEXT_PUBLIC keys
  if (supabaseUrl.isEmpty) {
    supabaseUrl = const String.fromEnvironment('NEXT_PUBLIC_SUPABASE_URL');
  }
  if (supabaseAnonKey.isEmpty) {
    supabaseAnonKey = const String.fromEnvironment('NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY');
  }

  // Try to get values from environment (for desktop/mobile)
  // Fallback to trying to get from window object (for web)
  if (kIsWeb) {
    // Web specific logic removed to allow cross-platform compilation
    // Meta tags can be accessed via package:web if needed
  } else {
    // For desktop/mobile, use environment variables if still empty
    if (supabaseUrl.isEmpty) {
      supabaseUrl = Platform.environment['SUPABASE_URL'] ??
                    Platform.environment['NEXT_PUBLIC_SUPABASE_URL'] ?? '';
    }
    if (supabaseAnonKey.isEmpty) {
      supabaseAnonKey = Platform.environment['SUPABASE_ANON_KEY'] ??
                        Platform.environment['NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY'] ?? '';
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

  // Initialize Sentry
  await Sentry.init(
    Options(
      dsn: "https://7cc42debf6799ebf01b893f3e75e5323@o4511887475933184.ingest.us.sentry.io/4511887481896960",
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      tracesSampleRate: 1.0,
    ),
  );

  runApp(const ProviderScope(child: FrinkelsApp()));
}