import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../../../../core/config/env_config.dart';
import '../../../../core/failures/failure.dart';
import '../../../../core/clerk/clerk_init.dart';
import '../../domain/entities/user.dart';
import 'auth_remote_data_source.dart';
import 'package:clerk_auth/clerk_auth.dart' as clerk;

class ClerkAuthRemoteDataSource implements AuthRemoteDataSource {
  final String _baseUrl;

  ClerkAuthRemoteDataSource({
    String? baseUrl,
  }) : _baseUrl = baseUrl ?? 'https://api.clerk.dev/v1';

  String get _publishableKey => EnvConfig.clerkPublishableKey;
  String get _secretKey => EnvConfig.clerkSecretKey;

  Map<String, String> get _headers {
    final authKey = _secretKey.isNotEmpty ? _secretKey : _publishableKey;
    return {
      'Authorization': 'Bearer $authKey',
      'Content-Type': 'application/json',
    };
  }

  @override
  Future<User> signUpWithEmailPassword(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      final nameParts = displayName.trim().split(' ');
      final firstName = nameParts.isNotEmpty ? nameParts[0] : '';
      final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      final response = await http.post(
        Uri.parse('$_baseUrl/users'),
        headers: _headers,
        body: jsonEncode({
          'email_address': [email],
          'password': password,
          'first_name': firstName,
          'last_name': lastName,
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
      final response = await http.post(
        Uri.parse('$_baseUrl/sessions'),
        headers: _headers,
        body: jsonEncode({
          'identifier': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> sessionData = jsonDecode(response.body);
        final String userId = sessionData['user_id'];

        final userResponse = await http.get(
          Uri.parse('$_baseUrl/users/$userId'),
          headers: _headers,
        );

        if (userResponse.statusCode == 200) {
          final Map<String, dynamic> userData = jsonDecode(userResponse.body);
          return _mapClerkUserToUser(userData);
        } else {
          throw const ServerFailure(message: 'Failed to fetch user after sign in');
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
      await clerkInstance.oauthSignIn(
        strategy: clerk.Strategy.oauthGoogle,
        redirect: Uri.parse('https://frinkels.com/oauth/callback'),
      );

      // Wait a moment for the user to be set
      await Future.delayed(const Duration(seconds: 2));

      final clerkUser = clerkInstance.user;
      if (clerkUser != null) {
        return _mapClerkUserToUserFromClerkUser(clerkUser);
      } else {
        throw const ServerFailure(message: 'Google sign-in failed: No user found after authentication');
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
      await clerkInstance.signOut();
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
      final resendApiKey = EnvConfig.resendApiKey;
      if (resendApiKey.isNotEmpty) {
        return _sendResetEmailViaResend(email, resendApiKey);
      }

      final response = await http.post(
        Uri.parse('$_baseUrl/email_addresses/$email/external_accounts'),
        headers: _headers,
        body: jsonEncode({
          'url': '/reset-password',
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        final String errorMessage = errorData['errors']?[0]['message'] ?? 'Failed to send reset email';
        throw ServerFailure(message: errorMessage);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error sending reset email: $e');
      }
      throw ServerFailure(message: 'Error sending reset email: $e');
    }
  }

  Future<void> _sendResetEmailViaResend(String email, String apiKey) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.resend.com/emails'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'from': 'FRINKELS <noreply@frinkels.com>',
          'to': [email],
          'subject': 'Reset your FRINKELS password',
          'html': '''
            <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
              <h2>Password Reset Request</h2>
              <p>We received a request to reset your password for your FRINKELS account.</p>
              <p>Click the button below to reset your password:</p>
              <a href="https://frinkels.com/reset-password"
                 style="background-color: #2563eb; color: white; padding: 12px 24px;
                        text-decoration: none; border-radius: 4px; display: inline-block;">
                Reset Password
              </a>
              <p>If you didn't request this, please ignore this email.</p>
              <p>This link will expire in 1 hour.</p>
              <hr style="border: none; border-top: 1px solid #eee; margin: 20px 0;">
              <p style="font-size: 12px; color: #666;">
                This is an automated message, please do not reply to this email.
              </p>
            </div>
          ''',
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        final String errorMessage = errorData['error']?['message'] ??
            errorData['message'] ??
            'Failed to send reset email via Resend';
        throw ServerFailure(message: errorMessage);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Resend email error: $e');
      }
      throw ServerFailure(message: 'Error sending reset email via Resend: $e');
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final clerkUser = clerkInstance.user;
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
      final clerkUser = clerkInstance.user;
      if (clerkUser == null) {
        throw const ServerFailure(message: 'User not signed in');
      }

      final Map<String, dynamic> updateData = {
        'first_name': data['first_name'],
        'last_name': data['last_name'],
      };

      if (data['public_metadata'] != null) {
        final currentPublicMetadata = clerkUser.publicMetadata ?? {};
        updateData['public_metadata'] = {
          ...currentPublicMetadata,
          ...data['public_metadata'],
        };
      }

      final response = await http.patch(
        Uri.parse('$_baseUrl/users/${clerkUser.id}'),
        headers: _headers,
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
      final clerkUser = clerkInstance.user;
      if (clerkUser == null) {
        throw const ServerFailure(message: 'User not signed in');
      }

      final Map<String, dynamic> updateData = {
        'public_metadata': {
          ...(clerkUser.publicMetadata ?? {}),
          'is_onboarded': true,
          ...onboardingData,
        },
      };

      final response = await http.patch(
        Uri.parse('$_baseUrl/users/${clerkUser.id}'),
        headers: _headers,
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
    final List<dynamic>? emailAddresses = userData['email_addresses'] as List<dynamic>?;
    String email = '';
    bool emailVerified = false;

    if (emailAddresses != null && emailAddresses.isNotEmpty) {
      final primaryEmailMap = emailAddresses.firstWhere(
            (e) => e['id'] == userData['primary_email_address_id'],
            orElse: () => emailAddresses.first,
          );

      final emailValue = primaryEmailMap['email_address'];
      email = emailValue is String ? emailValue : '';

      final verificationMap = primaryEmailMap['verification'];
      if (verificationMap is Map<String, dynamic>) {
        final status = verificationMap['status'];
        emailVerified = status is String && status == 'verified';
      }
    }

    final firstName = userData['first_name'] as String? ?? '';
    final lastName = userData['last_name'] as String? ?? '';
    final fullName = '$firstName $lastName'.trim();

    final Map<String, dynamic> publicMeta = userData['public_metadata'] is Map<String, dynamic>
        ? userData['public_metadata'] as Map<String, dynamic>
        : {};

    return User(
      id: userData['id'] as String,
      email: email,
      name: fullName.isNotEmpty ? fullName : null,
      username: userData['username'] as String?,
      profession: publicMeta['profession'] as String?,
      skills: (publicMeta['skills'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      interests: (publicMeta['interests'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      bio: publicMeta['bio'] as String?,
      location: publicMeta['location'] as String?,
      availability: publicMeta['availability'] as String?,
      avatarUrl: userData['profile_image_url'] as String?,
      coverUrl: publicMeta['cover_url'] as String?,
      emailVerified: emailVerified,
      isOnboarded: publicMeta['is_onboarded'] as bool? ?? false,
      createdAt: userData['created_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              userData['created_at'] is int
                  ? userData['created_at'] as int
                  : int.tryParse(userData['created_at'].toString()) ?? 0,
            )
          : DateTime.now(),
    );
  }

  User _mapClerkUserToUserFromClerkUser(clerk.User user) {
    // Extract email from emailAddresses if available
    String email = '';
    bool emailVerified = false;

    if (user.emailAddresses != null) {
      final emailAddresses = user.emailAddresses!;
      if (emailAddresses.isNotEmpty) {
        // Find primary email
        final primaryEmail = emailAddresses.firstWhere(
              (e) => e.id == user.primaryEmailAddressId,
              orElse: () => emailAddresses.first,
            );
        email = primaryEmail.emailAddress;
        emailVerified = primaryEmail.verification.status == 'verified';
      }
    }

    return User(
      id: user.id,
      email: email,
      name: ((user.firstName?.isNotEmpty ?? false) || (user.lastName?.isNotEmpty ?? false))
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
      emailVerified: emailVerified,
      isOnboarded: user.publicMetadata['is_onboarded'] as bool? ?? false,
      createdAt: user.createdAt != null ? user.createdAt : DateTime.now(),
    );
  }
}
