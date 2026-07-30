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
import 'package:frinkels/features/auth/domain/entities/user.dart';
import 'package:frinkels/features/auth/domain/repositories/user_repository.dart';
import 'package:frinkels/core/failures/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:frinkels/features/auth/presentation/screens/login_screen.dart';
import 'package:frinkels/features/auth/presentation/screens/signup_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User, AuthState;
import 'package:flutter/services.dart';

import 'package:frinkels/features/auth/domain/usecases/sign_in_with_google.dart';

// Fake UserRepository that returns a successful login and logout
class FakeUserRepo implements UserRepository {
  @override
  Future<Either<Failure, User>> signIn(String email, String password) async {
    return Right(User(id: '1', email: email, name: 'Test User', createdAt: DateTime.now()));
  }

  @override
  Future<Either<Failure, User>> signInWithGoogle() async {
    return Right(User(id: '1', email: 'google@test.com', name: 'Google User', createdAt: DateTime.now()));
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, User>> signUp({required String email, required String password, required String name}) async {
    return Right(User(id: '1', email: email, name: name, createdAt: DateTime.now()));
  }

  // We need to implement the other methods, but we won't use them in this test.
  @override
  Future<Either<Failure, void>> resetPassword(String email) => throw UnimplementedError();
  @override
  Future<Either<Failure, User?>> getCurrentUser() => throw UnimplementedError();
  @override
  Future<Either<Failure, User>> updateUserProfile(String displayName) => throw UnimplementedError();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // Mock SharedPreferences for Supabase initialization
    final TestDefaultBinaryMessengerBinding binding = TestDefaultBinaryMessengerBinding.instance;
    final MethodChannel channel = MethodChannel('plugins.flutter.io/shared_preferences');
    binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'getAll') {
        return <String, dynamic>{}; // return an empty map
      } else if (methodCall.method == 'setString') {
        return true;
      } else if (methodCall.method == 'initWithDefaults') {
        return true;
      } else if (methodCall.method == 'clear') {
        return true;
      }
      return null;
    });

    // We don't need to initialize Supabase because we are using fake use cases
    // But we need to initialize it to avoid the error about Supabase.instance not being initialized
    await Supabase.initialize(
      url: 'https://test.supabase.co',
      publishableKey: 'test-anon-key',
    );
  });

  testWidgets('Signup flow: navigate to signup, sign up, go to home',
      (WidgetTester tester) async {
    // Set a larger screen size to ensure all widgets are visible and clickable
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // Override the authControllerProvider to use our fake use cases
          authControllerProvider.overrideWith(
            (ref) => AuthController(
              signUpUseCase: SignUp(FakeUserRepo()),
              signInUseCase: SignIn(FakeUserRepo()),
              signInWithGoogleUseCase: SignInWithGoogle(FakeUserRepo()),
              signOutUseCase: SignOut(FakeUserRepo()),
              resetPasswordUseCase: ResetPassword(FakeUserRepo()),
              getCurrentUserUseCase: GetCurrentUser(FakeUserRepo()),
              updateUserProfileUseCase: UpdateUserProfile(FakeUserRepo()),
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

    // Wait for the splash screen to complete and navigate to login (since no session)
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Expect to be on the login screen
    expect(find.byType(LoginScreen), findsOneWidget);

    // Tap on the sign up link to navigate to signup screen
    // Find the TextButton that contains the text "Sign up" in the login form
    final Finder signUpLinkFinder = find.textContaining('Sign up');
    expect(signUpLinkFinder, findsOneWidget);
    await tester.tap(signUpLinkFinder);
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Expect to be on the signup screen
    expect(find.byType(SignupScreen), findsOneWidget);

    // Enter name, email and password
    await tester.enterText(find.byType(TextFormField).at(0), 'Test User');
    await tester.enterText(find.byType(TextFormField).at(1), 'test@example.com');
    await tester.enterText(find.byType(TextFormField).at(2), 'password');

    // Tap the sign up button (Create Account)
    await tester.tap(find.text('Create Account').first);
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Expect to be on the home screen (in debug mode, we show a simple scaffold)
    expect(find.text('Home Screen (Test)'), findsOneWidget);

    // TODO: Add logout test
    // For now, we just check that we can navigate to home after signup
  });
}