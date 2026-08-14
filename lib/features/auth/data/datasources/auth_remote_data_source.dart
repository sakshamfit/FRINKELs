import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/failures/failure.dart';
import '../../domain/entities/user.dart';

abstract class AuthRemoteDataSource {
  Future<User> signUpWithEmailPassword(
    String email,
    String password,
    String displayName,
  );
  Future<User> signInWithEmailPassword(String email, String password);
  Future<User> signInWithGoogle();
  Future<void> signOut();
  Future<void> sendPasswordResetEmail(String email);
  Future<User?> getCurrentUser();
  Future<User> updateUserProfile(Map<String, dynamic> data);
  Future<User> completeOnboarding(Map<String, dynamic> onboardingData);
}

class SupabaseAuthRemoteDataSource implements AuthRemoteDataSource {
  final sb.SupabaseClient supabaseClient;

  SupabaseAuthRemoteDataSource(this.supabaseClient);

  User _mapSbUserToUser(sb.User user) {
    final metadata = user.userMetadata ?? {};
    return User(
      id: user.id,
      email: user.email ?? '',
      name: metadata['full_name'] as String?,
      username: metadata['username'] as String?,
      profession: metadata['profession'] as String?,
      skills:
          (metadata['skills'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      interests:
          (metadata['interests'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      bio: metadata['bio'] as String?,
      location: metadata['location'] as String?,
      availability: metadata['availability'] as String?,
      avatarUrl: metadata['avatar_url'] as String?,
      coverUrl: metadata['cover_url'] as String?,
      emailVerified: user.emailConfirmedAt != null,
      isOnboarded: metadata['is_onboarded'] as bool? ?? false,
      createdAt: DateTime.parse(user.createdAt),
    );
  }

  @override
  Future<User> signUpWithEmailPassword(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': displayName, 'is_onboarded': false},
      );

      final sb.User? user = response.user;
      if (user == null) {
        throw const ServerFailure(message: 'Failed to create user');
      }

      return _mapSbUserToUser(user);
    } on sb.AuthException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: 'Error signing up: $e');
    }
  }

  @override
  Future<User> signInWithEmailPassword(String email, String password) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final sb.User? user = response.user;
      if (user == null) {
        throw const ServerFailure(message: 'Invalid credentials');
      }

      return _mapSbUserToUser(user);
    } on sb.AuthException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: 'Error signing in: $e');
    }
  }

  @override
  Future<User> signInWithGoogle() async {
    try {
      // 1. Google Sign In
      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId:
            '570972122297-hi52i3d0ee6kiahslits622ubd9easdf.apps.googleusercontent.com',
      );
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw const ServerFailure(message: 'Google Sign-In cancelled');
      }

      // 2. Firebase Auth
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;
      final String? accessToken = googleAuth.accessToken;

      if (idToken == null) {
        throw const ServerFailure(message: 'Google ID Token is null');
      }

      final firebase.AuthCredential credential =
          firebase.GoogleAuthProvider.credential(
            accessToken: accessToken,
            idToken: idToken,
          );

      final firebase.UserCredential firebaseUserCredential = await firebase
          .FirebaseAuth
          .instance
          .signInWithCredential(credential);

      final firebase.User? firebaseUser = firebaseUserCredential.user;
      if (firebaseUser == null) {
        throw const ServerFailure(message: 'Firebase Authentication failed');
      }

      // 3. Supabase Auth with ID Token
      final sb.AuthResponse response = await supabaseClient.auth
          .signInWithIdToken(
            provider: sb.OAuthProvider.google,
            idToken: idToken,
          );

      final sb.User? user = response.user;
      if (user == null) {
        throw const ServerFailure(message: 'Supabase Authentication failed');
      }

      return _mapSbUserToUser(user);
    } on firebase.FirebaseAuthException catch (e) {
      throw ServerFailure(message: e.message ?? 'Firebase Auth Error');
    } on sb.AuthException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: 'Error signing in with Google: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.wait([
        supabaseClient.auth.signOut(),
        firebase.FirebaseAuth.instance.signOut(),
        GoogleSignIn(
          serverClientId:
              '570972122297-hi52i3d0ee6kiahslits622ubd9easdf.apps.googleusercontent.com',
        ).signOut(),
      ]);
    } on sb.AuthException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: 'Failed to sign out: $e');
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await supabaseClient.auth.resetPasswordForEmail(email);
    } on sb.AuthException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: 'Failed to send reset email: $e');
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final sb.User? user = supabaseClient.auth.currentUser;
      if (user == null) return null;
      return _mapSbUserToUser(user);
    } catch (e) {
      throw ServerFailure(message: 'Failed to get current user: $e');
    }
  }

  @override
  Future<User> updateUserProfile(Map<String, dynamic> data) async {
    try {
      final response = await supabaseClient.auth.updateUser(
        sb.UserAttributes(data: data),
      );
      final user = response.user;
      if (user == null) throw const ServerFailure(message: 'Update failed');
      return _mapSbUserToUser(user);
    } on sb.AuthException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<User> completeOnboarding(Map<String, dynamic> onboardingData) async {
    return updateUserProfile({...onboardingData, 'is_onboarded': true});
  }
}
