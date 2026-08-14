# Authentication System Documentation

## Overview
The FRINKELS authentication system implements a modern authentication solution using Clerk as the primary authentication backend, while maintaining Supabase for database/storage and Firebase for other services (analytics, crash reporting, etc.). The system follows Clean Architecture principles with clear separation between domain, data, and presentation layers.

## Features Implemented
- ��� � � ✅ Email/Password Sign Up
- ��� � � ✅ Email/Password Sign In  
- ��� � � ✅ Google Sign-In (via Clerk OAuth)
- ��� � � ✅ Sign Out (all providers)
- ��� � � ✅ Password Reset via Email
- ��� � � ✅ Current User Session Management
- ��� � � ✅ User Profile Updates
- ��� � � ✅ Onboarding Completion Tracking
- ��� � � ✅ Real-time Auth State Change Listening
- ��� � � ✅ Clerk-hosted User Profile Management
- ��� � � ✅ Multi-factor Authentication (via Clerk dashboard configuration)
- ��� � � ✅ Social Login (GitHub, Facebook, etc. via Clerk dashboard)

## Architecture

### Layer Structure
```
lib/features/auth/
├── data/
│   └── datasources/
│       └── auth_remote_data_source.dart    # Clerk + HTTP backend API implementation
├── domain/
│   ├── entities/
│   │   └── user.dart                       # Domain User entity
│   ├── repositories/
│   │   └── auth_repository.dart            # Repository interface (abstract)
│   └── usecases/                           # Business logic use cases
│       ├── sign_in.dart
│       ├── sign_up.dart
│       ├── sign_out.dart
│       ├── reset_password.dart
│       ├── get_current_user.dart
│       ├── update_user_profile.dart
│       └── complete_onboarding.dart
���└── presentation/
    └── controllers/
        └── auth_controller.dart            # State management controller
```

### Data Flow
1. **Presentation Layer** → AuthController (StateNotifier)
2. **Presentation Layer** → Use Cases (via Provider)
3. **Domain Layer** → Use Cases call Repository Interface
4. **Data Layer** → Repository Impl uses Data Sources (Clerk SDK + HTTP)
5. **Data Layer** → Data Sources call Clerk APIs (Frontend SDK + Backend API)
6. **Data Layer** → Returns data to Repository
7. **Domain Layer** → Repository returns to Use Cases
8. **Presentation Layer** → Use Cases update Controller State
9. **Presentation Layer** → Controller notifies UI via ChangeNotifier

## Key Implementation Details

### ClerkAuthRemoteDataSource (lib/features/auth/data/datasources/clerk_auth_remote_data_source.dart)
This is the core implementation that handles:
- **Clerk Authentication**: Email/password, social logins, magic links via Clerk
- **Hybrid Approach**: Uses Clerk Frontend SDK for real-time operations and Clerk Backend API for operations requiring server-side validation
- **User Mapping**: Maps Clerk User objects to domain User entities
- **Error Handling**: Converts platform exceptions to domain Failure types
- **Metadata Management**: Properly handles public_metadata for profile data

#### Authentication Methods:
1. **signUpWithEmailPassword**: Uses Clerk Backend API `/users` endpoint
2. **signInWithEmailPassword**: Uses Clerk Backend API `/sessions` then `/users/{id}`
3. **signInWithGoogle**: Uses Clerk.oauthSignIn('google') with fallback to signInWithOAuth
4. **signOut**: Uses Clerk.signOut()
5. **sendPasswordResetEmail**: Uses Clerk Backend API `/email_addresses/{email}/external_accounts`
6. **getCurrentUser**: Returns Clerk.user mapped to domain User
7. **updateUserProfile**: Uses Clerk Backend API PATCH `/users/{id}` with user ID from Clerk.user
8. **completeOnboarding**: Uses Clerk Backend API PATCH `/users/{id}` to set is_onboarded: true

### Domain Entities (lib/features/auth/domain/entities/user.dart)
The User entity contains all user profile information:
- id, email, name, username, profession
- skills, interests, bio, location, availability
- avatarUrl, coverUrl, emailVerified, isOnboarded
- createdAt timestamp

### Use Cases
Each use case follows the pattern:
- Takes specific parameters (email/password, etc.)
- Calls the appropriate repository method
- Returns Either<Failure, User> or Either<Failure, void>
- Handles error mapping to domain Failure types

### AuthController (lib/features/auth/presentation/controllers/auth_controller.dart)
Manages authentication state using ChangeNotifier:
- **State Properties**: isLoading, isAuthenticated, user, errorMessage, successMessage
- **Real-time Listening**: Subscribes to Clerk.userFlow.listen() for real-time auth state updates
- **Methods**: signUp, signIn, signInWithGoogle, signOut, resetPassword, getCurrentUser, updateUserProfile, completeOnboarding
- **Provider Integration**: Uses ChangeNotifierProvider for state distribution

## Configuration

### Environment Variables
The system requires these environment variables:
- `CLERK_PUBLISHABLE_KEY` or `NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY`: Clerk publishable key
- Optional fallback to platform environment variables for desktop/mobile builds

### Clerk Dashboard Configuration
To fully utilize the authentication system, configure these in the Clerk dashboard:
1. **Social Connections**: Enable Google, GitHub, Facebook, etc. authentication providers
2. **Multi-Factor Authentication**: Enable TOTP/MFA options
3. **Email Verification**: Configure email verification settings
4. **Username Settings**: Enable/disable usernames as needed
5. **Profile Fields**: Configure which profile fields to collect (first name, last name, etc.)
6. **Redirect URLs**: Set up sign-in/sign-out redirect URLs for web/mobile platforms

### Platform Setup
#### Android
- Internet permission in AndroidManifest.xml (already configured)
- No special configuration needed for Clerk

#### iOS
- Associated domains in Info.plist for Clerk OAuth redirects (already configured)
- No special configuration needed for Clerk

#### Web
- Clerk automatically handles web authentication flows
- Ensure proper domain configuration in Clerk dashboard

## Security Implementation
- **Password Handling**: Never stored or logged (handled by Clerk)
- **Token Security**: Session tokens managed securely by Clerk SDK
- **Session Management**: Automatic refresh via Clerk SDK
- **CSRF Protection**: Built into Clerk SDK
- **Rate Limiting**: Handled by Clerk service
- **Input Validation**: Client-side validation in forms + server-side Clerk validation
- **Data Privacy**: Clerk handles GDPR compliance and data protection

## Integration Points
1. **App Initialization**: Clerk initialized in main.dart with publishable key from environment
2. **Supabase/Firebase Services**: Still initialized for database/storage and other Firebase services
3. **Router Integration**: Auth routes protected via route guards using auth state
4. **State Sharing**: AuthController provided via Riverpod for app-wide access
5. **Protected Routes**: Uses auth state to conditionally show/hide content

## Error Handling
All methods follow this pattern:
```dart
try {
  // Clerk-specific call
  final result = await clerkMethod();
  return Right(result);
} on Exception catch (e) {
  return Left(ServerFailure(message: 'Authentication error: $e'));
}
```

## Testing Considerations
- Unit tests for each use case mocking repository
- Integration tests for data sources with test Clerk instance (if available)
- Widget tests for auth pages
- Manual testing flows:
  1. New user registration (email/password)
  2. Email verification flow (if enabled)
  3. Password reset flow
  4. Google Sign-In flow
  5. Profile update flow
  6. Sign out and session clearance
  7. Social logins (GitHub, Facebook if configured)

## Future Enhancements
- [ ] Anonymous auth support (if needed for specific features)
- [ ] Magic link/passwordless email auth (via Clerk configuration)
- [ ] Phone number authentication (via Clerk configuration)
- [ ] Multi-factor authentication enforcement (via Clerk dashboard)
- [ ] Session persistence optimization
- [ ] Biometric authentication for sensitive operations (device-level)
- [ ] Password strength validation (via Clerk dashboard)
- [ ] Email change verification workflow
- [ ] Admin user roles and permissions (via Clerk public_metadata)
- [ ] Enterprise SSO (SAML, Azure AD via Clerk Enterprise)