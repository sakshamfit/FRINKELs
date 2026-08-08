import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

import '../../domain/entities/user.dart';
import '../../domain/usecases/get_current_user.dart' as get_current_user;
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_in_with_google.dart';
import '../../domain/usecases/sign_out.dart' as sign_out;
import '../../domain/usecases/sign_up.dart';
import '../../domain/usecases/reset_password.dart';
import '../../domain/usecases/update_user_profile.dart';
import '../../domain/usecases/no_params.dart';
import '../../domain/usecases/complete_onboarding.dart' as onboarding;

// State
class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final User? user;
  final String? errorMessage;
  final String? successMessage;

  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.user,
    this.errorMessage,
    this.successMessage,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    User? user,
    String? errorMessage,
    String? successMessage,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }
}

// State Notifier changed to ChangeNotifier
class AuthController extends ChangeNotifier {
  final SignUp signUpUseCase;
  final SignIn signInUseCase;
  final SignInWithGoogle signInWithGoogleUseCase;
  final sign_out.SignOut signOutUseCase;
  final ResetPassword resetPasswordUseCase;
  final get_current_user.GetCurrentUser getCurrentUserUseCase;
  final UpdateUserProfile updateUserProfileUseCase;
  final onboarding.CompleteOnboarding completeOnboardingUseCase;
  StreamSubscription<dynamic>? _authStateSubscription;

  AuthState _state = const AuthState();

  AuthState get state => _state;

  AuthController({
    required this.signUpUseCase,
    required this.signInUseCase,
    required this.signInWithGoogleUseCase,
    required this.signOutUseCase,
    required this.resetPasswordUseCase,
    required this.getCurrentUserUseCase,
    required this.updateUserProfileUseCase,
    required this.completeOnboardingUseCase,
  }) {
    _authStateSubscription = Supabase.instance.client.auth.onAuthStateChange
        .listen((data) {
      final session = data.session;
      final sbUser = session?.user; // Renamed to avoid conflict

      // Update our state based on Supabase session
      if (sbUser != null) {
        final metadata = sbUser.userMetadata ?? {};
        _state = _state.copyWith(
          isAuthenticated: true,
          user: User(
            id: sbUser.id,
            email: sbUser.email ?? '',
            name: metadata['full_name'] as String?,
            username: metadata['username'] as String?,
            profession: metadata['profession'] as String?,
            skills: (metadata['skills'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
            interests: (metadata['interests'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
            bio: metadata['bio'] as String?,
            location: metadata['location'] as String?,
            availability: metadata['availability'] as String?,
            avatarUrl: metadata['avatar_url'] as String?,
            coverUrl: metadata['cover_url'] as String?,
            emailVerified: sbUser.emailConfirmedAt != null,
            isOnboarded: metadata['is_onboarded'] as bool? ?? false,
            createdAt: sbUser.createdAt != null ? DateTime.parse(sbUser.createdAt) : DateTime.now(),
          ),
        );
      } else {
        _state = _state.copyWith(
          isAuthenticated: false,
          user: null,
        );
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }

  Future<void> signUp(String email, String password, String name) async {
    debugPrint('AUTH: Signing up $email');
    _state = _state.copyWith(isLoading: true, errorMessage: null);
    notifyListeners();
    try {
      final result = await signUpUseCase.call(
        SignUpParams(email: email, password: password, name: name),
      );
      result.fold(
        (failure) {
          debugPrint('AUTH: Sign up failure: ${failure.message}');
          _state = _state.copyWith(
            isLoading: false,
            errorMessage: failure.message,
          );
        },
        (user) {
          debugPrint('AUTH: Sign up success: ${user.email}');
          _state = _state.copyWith(
            isLoading: false,
            isAuthenticated: true,
            user: user,
          );
        },
      );
    } catch (e) {
      debugPrint('AUTH: Sign up unexpected error: $e');
      _state = _state.copyWith(
        isLoading: false,
        errorMessage: 'Unexpected error: $e',
      );
    } finally {
      notifyListeners();
    }
  }

  Future<void> signIn(String email, String password) async {
    debugPrint('AUTH: Signing in $email');
    _state = _state.copyWith(isLoading: true, errorMessage: null);
    notifyListeners();
    try {
      final result = await signInUseCase.call(
        SignInParams(email: email, password: password),
      );
      result.fold(
        (failure) {
          debugPrint('AUTH: Sign in failure: ${failure.message}');
          _state = _state.copyWith(
            isLoading: false,
            errorMessage: failure.message,
          );
        },
        (user) {
          debugPrint('AUTH: Sign in success: ${user.email}');
          _state = _state.copyWith(
            isLoading: false,
            isAuthenticated: true,
            user: user,
          );
        },
      );
    } catch (e) {
      debugPrint('AUTH: Sign in unexpected error: $e');
      _state = _state.copyWith(
        isLoading: false,
        errorMessage: 'Unexpected error: $e',
      );
    } finally {
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle() async {
    debugPrint('AUTH: Signing in with Google');
    _state = _state.copyWith(isLoading: true, errorMessage: null);
    notifyListeners();
    try {
      final result = await signInWithGoogleUseCase.call(const NoParams());
      result.fold(
        (failure) {
          debugPrint('AUTH: Google Sign in failure: ${failure.message}');
          _state = _state.copyWith(
            isLoading: false,
            errorMessage: failure.message,
          );
        },
        (user) {
          debugPrint('AUTH: Google Sign in success: ${user.email}');
          _state = _state.copyWith(
            isLoading: false,
            isAuthenticated: true,
            user: user,
          );
        },
      );
    } catch (e) {
      debugPrint('AUTH: Google Sign in unexpected error: $e');
      _state = _state.copyWith(
        isLoading: false,
        errorMessage: 'Unexpected error: $e',
      );
    } finally {
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    _state = _state.copyWith(isLoading: true, errorMessage: null);
    notifyListeners();
    try {
      await signOutUseCase.call(const NoParams());
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to sign out: $e',
      );
    } finally {
      notifyListeners();
    }
  }

  Future<void> resetPassword(String email) async {
    _state = _state.copyWith(isLoading: true, errorMessage: null);
    notifyListeners();
    try {
      await resetPasswordUseCase.call(ResetPasswordParams(email: email));
      _state = _state.copyWith(
        isLoading: false,
        successMessage: 'Password reset link sent to $email',
      );
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to send reset email: $e',
      );
    } finally {
      notifyListeners();
    }
  }

  Future<void> getCurrentUser() async {
    _state = _state.copyWith(isLoading: true, errorMessage: null);
    notifyListeners();
    try {
      final result = await getCurrentUserUseCase.call(const NoParams());
      result.fold(
        (failure) => _state = _state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        ),
        (user) => _state = _state.copyWith(
          isLoading: false,
          isAuthenticated: user != null,
          user: user,
        ),
      );
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to get current user: $e',
      );
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateUserProfile(Map<String, dynamic> data) async {
    _state = _state.copyWith(isLoading: true, errorMessage: null);
    notifyListeners();
    try {
      final result = await updateUserProfileUseCase.call(UpdateUserProfileParams(data: data));
      result.fold(
        (failure) => _state = _state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        ),
        (user) => _state = _state.copyWith(
          isLoading: false,
          user: user,
          successMessage: 'Profile updated successfully',
        ),
      );
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to update profile: $e',
      );
    } finally {
      notifyListeners();
    }
  }

  Future<void> completeOnboarding(Map<String, dynamic> data) async {
    _state = _state.copyWith(isLoading: true, errorMessage: null);
    notifyListeners();
    try {
      final result = await completeOnboardingUseCase.call(data);
      result.fold(
        (failure) => _state = _state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        ),
        (user) => _state = _state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          user: user,
        ),
      );
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to complete onboarding: $e',
      );
    } finally {
      notifyListeners();
    }
  }
}
