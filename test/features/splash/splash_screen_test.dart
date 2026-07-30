import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frinkels/features/auth/presentation/controllers/auth_provider.dart';
import 'package:frinkels/features/auth/presentation/controllers/auth_controller.dart';
import 'package:frinkels/features/auth/domain/usecases/sign_in.dart';
import 'package:frinkels/features/auth/domain/usecases/sign_up.dart';
import 'package:frinkels/features/auth/domain/usecases/sign_out.dart';
import 'package:frinkels/features/auth/domain/usecases/reset_password.dart';
import 'package:frinkels/features/auth/domain/usecases/get_current_user.dart';
import 'package:frinkels/features/auth/domain/usecases/update_user_profile.dart';
import 'package:frinkels/features/auth/domain/entities/user.dart' as domain_user;
import 'package:frinkels/features/auth/domain/repositories/user_repository.dart';
import 'package:frinkels/core/failures/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:frinkels/features/auth/domain/usecases/sign_in_with_google.dart';

// Stub UserRepository that returns dummy results
class StubUserRepo implements UserRepository {
  @override
  Future<Either<Failure, domain_user.User>> signIn(String email, String password) =>
      Future.value(Right(domain_user.User(id: '1', email: 'test@test.com', name: 'Test User', createdAt: DateTime.now())));

  @override
  Future<Either<Failure, domain_user.User>> signInWithGoogle() =>
      Future.value(Right(domain_user.User(id: '1', email: 'google@test.com', name: 'Google User', createdAt: DateTime.now())));

  @override
  Future<Either<Failure, domain_user.User>> signUp({
    required String email,
    required String password,
    required String name,
  }) =>
      Future.value(Right(domain_user.User(id: '1', email: email, name: name, createdAt: DateTime.now())));

  @override
  Future<Either<Failure, void>> signOut() =>
      Future.value(const Right(null));

  @override
  Future<Either<Failure, void>> resetPassword(String email) =>
      Future.value(const Right(null));

  @override
  Future<Either<Failure, domain_user.User?>> getCurrentUser() =>
      Future.value(Right(domain_user.User(id: '1', email: 'test@test.com', name: 'Test User', createdAt: DateTime.now())));

  @override
  Future<Either<Failure, domain_user.User>> updateUserProfile(String displayName) =>
      Future.value(Right(domain_user.User(id: '1', email: 'test@test.com', name: displayName, createdAt: DateTime.now())));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // Mock SharedPreferences to avoid MissingPluginException
    final TestDefaultBinaryMessengerBinding binding = TestDefaultBinaryMessengerBinding.instance;
    final MethodChannel channel = MethodChannel('plugins.flutter.io/shared_preferences');
    final MethodChannel jsonChannel = MethodChannel('plugins.flutter.io/shared_preferences_macos');

    // Set up method call handlers
    binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'getAll') {
        return <String, dynamic>{};
      }
      if (methodCall.method == 'setString') {
        return Future.value(true);
      }
      if (methodCall.method == 'initWithDefaults') {
        return Future.value(true);
      }
      if (methodCall.method == 'clear') {
        return Future.value(true);
      }
      return Future.value(null);
    });

    binding.defaultBinaryMessenger.setMockMethodCallHandler(jsonChannel, (MethodCall methodCall) async {
      if (methodCall.method == 'getAll') {
        return <String, dynamic>{};
      }
      if (methodCall.method == 'setString') {
        return Future.value(true);
      }
      if (methodCall.method == 'initWithDefaults') {
        return Future.value(true);
      }
      if (methodCall.method == 'clear') {
        return Future.value(true);
      }
      return Future.value(null);
    });

    // Initialize SharedPreferences instance
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Initialize Supabase with dummy values (will be overridden by provider if needed)
    await Supabase.initialize(
      url: 'https://test.supabase.co',
      publishableKey: 'test-anon-key',
    );
  });

  testWidgets('SplashScreen displays FRINKELs title and tagline',
      (WidgetTester tester) async {
    // Set a larger screen size to ensure all widgets are visible
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // Override each use case provider to use our stub-based use cases
          signUpUseCaseProvider.overrideWithValue(SignUp(StubUserRepo())),
          signInUseCaseProvider.overrideWithValue(SignIn(StubUserRepo())),
          signInWithGoogleUseCaseProvider.overrideWithValue(SignInWithGoogle(StubUserRepo())),
          signOutUseCaseProvider.overrideWithValue(SignOut(StubUserRepo())),
          resetPasswordUseCaseProvider.overrideWithValue(ResetPassword(StubUserRepo())),
          getCurrentUserUseCaseProvider.overrideWithValue(GetCurrentUser(StubUserRepo())),
          updateUserProfileUseCaseProvider.overrideWithValue(UpdateUserProfile(StubUserRepo())),
          // Override authControllerProvider to return unauthenticated state
          authControllerProvider.overrideWith(
            (ref) => AuthController(
              signUpUseCase: ref.read(signUpUseCaseProvider),
              signInUseCase: ref.read(signInUseCaseProvider),
              signInWithGoogleUseCase: ref.read(signInWithGoogleUseCaseProvider),
              signOutUseCase: ref.read(signOutUseCaseProvider),
              resetPasswordUseCase: ref.read(resetPasswordUseCaseProvider),
              getCurrentUserUseCase: ref.read(getCurrentUserUseCaseProvider),
              updateUserProfileUseCase: ref.read(updateUserProfileUseCaseProvider),
            ),
          ),
        ],
        child: Builder(
          builder: (context) {
            return Consumer(
              builder: (context, ref, child) {
                return MaterialApp.router(
                  routerConfig: ref.watch(routerProvider),
                );
              },
            );
          },
        ),
      ),
    );

    // Initial render check
    expect(find.text('FRINKELs'), findsOneWidget);
    expect(find.text('Find. Connect. Grow.'), findsOneWidget);

    // Wait for the splash screen animation and navigation to complete
    // The splash screen has a 2800ms delay before navigating
    await tester.pumpAndSettle(const Duration(seconds: 5));
  });
}