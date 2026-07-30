import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_in_with_google.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/sign_up.dart';
import '../../domain/usecases/update_user_profile.dart';
import '../../domain/usecases/reset_password.dart';
import '../../domain/usecases/complete_onboarding.dart';
import '../controllers/auth_controller.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';

// Supabase client provider
final supabaseProvider = Provider<SupabaseClient>((ref) {
  // Initialize Supabase if not already done
  return Supabase.instance.client;
});

// Remote data source provider
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final supabase = ref.read(supabaseProvider);
  return SupabaseAuthRemoteDataSource(supabase);
});

// Repository provider
final authRepositoryProvider = Provider<UserRepository>((ref) {
  final remoteDataSource = ref.read(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(remoteDataSource);
});

// Use cases providers
final signUpUseCaseProvider = Provider<SignUp>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return SignUp(repository);
});

final signInUseCaseProvider = Provider<SignIn>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return SignIn(repository);
});

final signInWithGoogleUseCaseProvider = Provider<SignInWithGoogle>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return SignInWithGoogle(repository);
});

final signOutUseCaseProvider = Provider<SignOut>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return SignOut(repository);
});

final resetPasswordUseCaseProvider = Provider<ResetPassword>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return ResetPassword(repository);
});

final getCurrentUserUseCaseProvider = Provider<GetCurrentUser>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return GetCurrentUser(repository);
});

final updateUserProfileUseCaseProvider = Provider<UpdateUserProfile>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return UpdateUserProfile(repository);
});

final completeOnboardingUseCaseProvider = Provider<CompleteOnboarding>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return CompleteOnboarding(repository);
});

// Controller provider
final authControllerProvider = ChangeNotifierProvider<AuthController>((ref) {
  return AuthController(
    signUpUseCase: ref.read(signUpUseCaseProvider),
    signInUseCase: ref.read(signInUseCaseProvider),
    signInWithGoogleUseCase: ref.read(signInWithGoogleUseCaseProvider),
    signOutUseCase: ref.read(signOutUseCaseProvider),
    resetPasswordUseCase: ref.read(resetPasswordUseCaseProvider),
    getCurrentUserUseCase: ref.read(getCurrentUserUseCaseProvider),
    updateUserProfileUseCase: ref.read(updateUserProfileUseCaseProvider),
    completeOnboardingUseCase: ref.read(completeOnboardingUseCaseProvider),
  );
});

final routerProvider = Provider<GoRouter>((ref) {
  return AppRouter.create(ref);
});
