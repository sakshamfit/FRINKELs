import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:clerk_auth/clerk_auth.dart';
import 'package:frinkels/core/config/env_config.dart';
import 'package:path_provider/path_provider.dart';

/// Global instance of Clerk Auth State.
late final ClerkAuthState _clerkInstance;

/// Getter for the global Clerk Auth Instance.
ClerkAuthState get clerkInstance => _clerkInstance;

/// Initialize the Clerk instance. Must be called before using Clerk.
Future<void> initializeClerk() async {
  final getCacheDirectory = () async {
    final dir = await getApplicationDocumentsDirectory();
    return dir;
  };

  _clerkInstance = await ClerkAuthState.create(
    config: ClerkAuthConfig(
      publishableKey: EnvConfig.clerkPublishableKey,
      persistor: DefaultPersistor(getCacheDirectory: getCacheDirectory),
    ),
  );
}