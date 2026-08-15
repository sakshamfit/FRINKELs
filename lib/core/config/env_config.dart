import 'dart:io';
import 'package:flutter/foundation.dart';

class EnvConfig {
  static final Map<String, String> _envMap = {};
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    try {
      final envFile = File('.env');
      if (await envFile.exists()) {
        final lines = await envFile.readAsLines();
        for (final line in lines) {
          final trimmed = line.trim();
          if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
          final parts = trimmed.split('=');
          if (parts.length >= 2) {
            final key = parts[0].trim();
            final value = parts.sublist(1).join('=').trim();
            _envMap[key] = value;
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('EnvConfig initialization warning: $e');
      }
    }
  }

  static String get(String key, {String defaultValue = ''}) {
    // 1. Check loaded .env file map
    if (_envMap.containsKey(key) && _envMap[key]!.isNotEmpty) {
      return _envMap[key]!;
    }
    // 2. Check system environment
    if (!kIsWeb) {
      try {
        final sysVal = Platform.environment[key];
        if (sysVal != null && sysVal.isNotEmpty) {
          return sysVal;
        }
      } catch (_) {}
    }
    return defaultValue;
  }

  static String get clerkPublishableKey {
    const compileTimeKey = String.fromEnvironment('CLERK_PUBLISHABLE_KEY');
    if (compileTimeKey.isNotEmpty) return compileTimeKey;

    const compileTimeNextKey = String.fromEnvironment('NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY');
    if (compileTimeNextKey.isNotEmpty) return compileTimeNextKey;

    final key = get('NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY');
    if (key.isNotEmpty) return key;

    final altKey = get('CLERK_PUBLISHABLE_KEY');
    if (altKey.isNotEmpty) return altKey;

    return 'pk_test_Z2xvcmlvdXMtc3VuYmlyZC02NS5jbGVyay5hY2NvdW50cy5kZXYk';
  }

  static String get clerkSecretKey {
    const compileTimeKey = String.fromEnvironment('CLERK_SECRET_KEY');
    if (compileTimeKey.isNotEmpty) return compileTimeKey;
    return get('CLERK_SECRET_KEY');
  }

  static String get supabaseUrl {
    const compileTimeUrl = String.fromEnvironment('SUPABASE_URL');
    if (compileTimeUrl.isNotEmpty) return compileTimeUrl;

    const compileTimeNextUrl = String.fromEnvironment('NEXT_PUBLIC_SUPABASE_URL');
    if (compileTimeNextUrl.isNotEmpty) return compileTimeNextUrl;

    final url = get('SUPABASE_URL');
    if (url.isNotEmpty) return url;

    final nextUrl = get('NEXT_PUBLIC_SUPABASE_URL');
    if (nextUrl.isNotEmpty) return nextUrl;

    return 'https://qwllshdzcssqetgxmirc.supabase.co';
  }

  static String get supabaseAnonKey {
    const compileTimeKey = String.fromEnvironment('SUPABASE_ANON_KEY');
    if (compileTimeKey.isNotEmpty) return compileTimeKey;

    const compileTimeNextKey = String.fromEnvironment('NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY');
    if (compileTimeNextKey.isNotEmpty) return compileTimeNextKey;

    final key = get('SUPABASE_ANON_KEY');
    if (key.isNotEmpty) return key;

    final nextKey = get('NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY');
    if (nextKey.isNotEmpty) return nextKey;

    return 'sb_publishable_XFFvxculR68Mx4JKTNuEaQ_dnoFjeFB';
  }

  static String get resendApiKey {
    const compileTimeKey = String.fromEnvironment('RESEND_API_KEY');
    if (compileTimeKey.isNotEmpty) return compileTimeKey;
    return get('RESEND_API_KEY');
  }

  static String get groqApiKey {
    const compileTimeKey = String.fromEnvironment('GROQ_API_KEY');
    if (compileTimeKey.isNotEmpty) return compileTimeKey;
    return get('GROQ_API_KEY');
  }
}
