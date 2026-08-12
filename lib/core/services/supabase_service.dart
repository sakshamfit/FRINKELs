import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  SupabaseService._internal();

  static final SupabaseService _instance = SupabaseService._internal();

  factory SupabaseService() {
    return _instance;
  }

  late final SupabaseClient supabaseClient;

  Future<void> initialize(String url, String anonKey) async {
    await Supabase.initialize(url: url, publishableKey: anonKey);
    supabaseClient = Supabase.instance.client;
  }
}
