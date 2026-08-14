import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/foundation.dart';
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

class ClerkAuthRemoteDataSource implements AuthRemoteDataSource {
  final String _baseUrl;
  final String _publishableKey;

  ClerkAuthRemoteDataSource({
    String? baseUrl,
    String? publishableKey,
  })  : _baseUrl = baseUrl ?? 'https://api.clerk.dev/v1',
        _publishableKey = publishableKey ??
            const String.fromEnvironment('CLERK_PUBLISHABLE_KEY') ??
            const String.fromEnvironment('NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY') ??
            'pk_test_...'; // Fallback, should be replaced with actual key

  @override
  Future<User> signUpWithEmailPassword(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/users'),
        headers: {
          'Authorization': 'Bearer $_publishableKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email_address': [email],
          'password': password,
          'first_name': displayName.split(' ')[0] || '',
          'last_name':
              displayName.split(' ').length > 1
                  ? displayName.split(' ').sublist(1).join(' ')
                  : '',
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> userData = jsonDecode(response.body);
        return _mapClerkUserToUser(userData);
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        final String errorMessage = errorData['errors']?[0]['message'] ?? 'Failed to sign up';
        throw ServerFailure(message: errorMessage);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Clerk sign up error: $e');
      }
      throw ServerFailure(message: 'Error signing up: $e');
    }
  }

  @override
  Future<User> signInWithEmailPassword(String email, String password) async {
    try {
      // For sign in, we need to create a session
      final response = await http.post(
        Uri.parse('$_baseUrl/sessions'),
        headers: {
          'Authorization': 'Bearer $_publishableKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'identifier': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> sessionData = jsonDecode(response.body);
        final String userId = sessionData['user_id'];

        // Now fetch the user
        final userResponse = await http.get(
          Uri.parse('$_baseUrl/users/$userId'),
          headers: {
            'Authorization': 'Bearer $_publishableKey',
          },
        );

        if (userResponse.statusCode == 200) {
          final Map<String, dynamic> userData =
              jsonDecode(userResponse.body);
          return _mapClerkUserToUser(userData);
        } else {
          throw ServerFailure(message: 'Failed to fetch user after sign in');
        }
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        final String errorMessage = errorData['errors']?[0]['message'] ?? 'Failed to sign in';
        throw ServerFailure(message: errorMessage);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Clerk sign in error: $e');
      }
      throw ServerFailure(message: 'Error signing in: $e');
    }
  }

  @override
  Future<User> signInWithGoogle() async {
    try {
      // Attempt Google sign-in using Clerk's OAuth functionality
      // Based on common patterns, try different method names
      try {
        // Try the most likely method name first
        await Clerk.oauthSignIn('google');
      } catch (e) {
        if (kDebugMode) {
          print('oauthSignIn not found, trying signInWithOAuth: $e');
        }
        // Try alternative method name
        await Clerk.signInWithOAuth({ 'provider': 'google' });
      }

      // Check if we have a signed-in user
      final clerkUser = Clerk.user;
      if (clerkUser != null) {
        return _mapClerkUserToUserFromClerkUser(clerkUser);
      } else {
        // If no user is available, the sign-in may have failed or not completed
        throw ServerFailure(message: 'Google sign-in failed: No user found after authentication');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Clerk Google sign in error: $e');
      }
      throw ServerFailure(message: 'Error during Google sign-in: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Clerk.signOut();
    } catch (e) {
      if (kDebugMode) {
        print('Clerk sign out error: $e');
      }
      throw ServerFailure(message: 'Error signing out: $e');
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/email_addresses/$email/external_accounts'),
        headers: {
          'Authorization': 'Bearer $_publishableKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'url': '/reset-password',
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        final Map<String, dynamic> errorData =
            jsonDecode(response.body);
        final String errorMessage = errorData['errors']?[0]['message'] ??
            'Failed to send reset email';
        throw ServerFailure(message: errorMessage);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Clerk send reset email error: $e');
      }
      throw ServerFailure(message: 'Error sending reset email: $e');
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final clerkUser = Clerk.user;
      if (clerkUser == null) return null;
      return _mapClerkUserToUserFromClerkUser(clerkUser);
    } catch (e) {
      if (kDebugMode) {
        print('Clerk get current user error: $e');
      }
      throw ServerFailure(message: 'Error getting current user: $e');
    }
  }

  @override
  Future<User> updateUserProfile(Map<String, dynamic> data) async {
    try {
      // For updating user profile, we would use Clerk's Backend API
      // We need the user ID, which we can get from Clerk.user
      final clerkUser = Clerk.user;
      if (clerkUser == null) {
        throw ServerFailure(message: 'User not signed in');
      }

      // Prepare the data to send to Clerk API
      final Map<String, dynamic> updateData = {
        'first_name': data['first_name'],
        'last_name': data['last_name'],
      };

      // Handle public_metadata if it exists in the data
      if (data['public_metadata'] != null) {
        final currentPublicMetadata = clerkUser.publicMetadata ?? {};
        updateData['public_metadata'] = {
          ...currentPublicMetadata,
          ...data['public_metadata'],
        };
      }

      final response = await http.patch(
        Uri.parse('$_baseUrl/users/${clerkUser.id}'),
        headers: {
          'Authorization': 'Bearer $_publishableKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(updateData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = jsonDecode(response.body);
        return _mapClerkUserToUser(userData);
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        final String errorMessage = errorData['errors']?[0]['message'] ?? 'Failed to update user';
        throw ServerFailure(message: errorMessage);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Clerk update user profile error: $e');
      }
      throw ServerFailure(message: 'Error updating user profile: $e');
    }
  }

  @override
  Future<User> completeOnboarding(Map<String, dynamic> onboardingData) async {
    try {
      // For completing onboarding, we would update the user's public metadata
      // to set is_onboarded to true
      final clerkUser = Clerk.user;
      if (clerkUser == null) {
        throw ServerFailure(message: 'User not signed in');
      }

      // Prepare the data to send to Clerk API
      final Map<String, dynamic> updateData = {
        'public_metadata': {
          ...(clerkUser.publicMetadata ?? {}),
          'is_onboarded': true,
          ...onboardingData,
        },
      };

      final response = await http.patch(
        Uri.parse('$_baseUrl/users/${clerkUser.id}'),
        headers: {
          'Authorization': 'Bearer $_publishableKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(updateData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = jsonDecode(response.body);
        return _mapClerkUserToUser(userData);
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        final String errorMessage = errorData['errors']?[0]['message'] ?? 'Failed to complete onboarding';
        throw ServerFailure(message: errorMessage);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Clerk complete onboarding error: $e');
      }
      throw ServerFailure(message: 'Error completing onboarding: $e');
    }
  }

  User _mapClerkUserToUser(Map<String, dynamic> userData) {
    return User(
      id: userData['id'],
      email: (userData['email_addresses'] as List<dynamic>?)
              ?.firstWhere(
                (e) => e['id'] == userData['primary_email_address_id'],
                orElse: () => userData['email_addresses'].first,
              )?['email_address'] ??
          '',
      name: ((userData['first_name'] ?? '') + ' ' +
              (userData['last_name'] ?? ''))
          .trim()
          .isNotEmpty
          ? ((userData['first_name'] ?? '') + ' ' +
              (userData['last_name'] ?? ''))
          .trim()
          : null,
      username: userData['username'],
      profession: userData['public_metadata']?['profession'] as String?,
      skills: (userData['public_metadata']?['skills'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      interests: (userData['public_metadata']?['interests'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      bio: userData['public_metadata']?['bio'] as String?,
      location: userData['public_metadata']?['location'] as String?,
      availability: userData['public_metadata']?['availability'] as String?,
      avatarUrl: userData['profile_image_url'],
      coverUrl: userData['public_metadata']?['cover_url'] as String?,
      emailVerified: (userData['email_addresses'] as List<dynamic>?)
              ?.firstWhere(
                (e) => e['id'] == userData['primary_email_address_id'],
                orElse: () => userData['email_addresses'].first,
              )?['verification']?['status'] ==
          'verified',
      isOnboarded: userData['public_metadata']?['is_onboarded'] as bool? ??
          false,
      createdAt: userData['created_at'] != null
          ? DateTime.parse(userData['created_at'])
          : DateTime.now(),
    );
  }

  User _mapClerkUserToUserFromClerkUser(ClerkUser user) {
    return User(
      id: user.id,
      email: user.emailAddress,
      name: user.firstName?.isNotEmpty == true || user.lastName?.isNotEmpty == true
          ? '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim()
          : null,
      username: user.username,
      profession: user.publicMetadata['profession'] as String?,
      skills: (user.publicMetadata['skills'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      interests: (user.publicMetadata['interests'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      bio: user.publicMetadata['bio'] as String?,
      location: user.publicMetadata['location'] as String?,
      availability: user.publicMetadata['availability'] as String?,
      avatarUrl: user.imageUrl,
      coverUrl: user.publicMetadata['cover_url'] as String?,
      emailVerified: user.emailAddress != null &&
                     (user.emailAddressVerifiedAt != null ||
                      user.primaryEmailAddressID != null),
      isOnboarded: user.publicMetadata['is_onboarded'] as bool? ?? false,
      createdAt: user.createdAt != null
          ? DateTime.parse(user.createdAt)
          : DateTime.now(),
    );
  }
}