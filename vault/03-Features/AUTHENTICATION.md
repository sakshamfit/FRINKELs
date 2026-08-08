# Auth Feature Architecture Plan

## Folder Structure
lib/
└── features/
    └── auth/
        ├── data/
        │   ├── datasources/
        │   │   ├── auth_remote_data_source.dart
        │   │   └── auth_local_data_source.dart
        │   ├── models/
        │   │   ├── user_model.dart
        │   │   └── auth_response_model.dart
        │   └── repositories/
        │       └── auth_repository_impl.dart
        ├── domain/
        │   ├── repositories/
        │   │   └── auth_repository.dart
        │   └── usecases/
        │       ├── sign_in.dart
        │       ├── sign_up.dart
        │       ├── sign_out.dart
        │       ├── reset_password.dart
        │       └── get_current_user.dart
        └── presentation/
            ├── controllers/
            │   ├── auth_controller.dart
            │   └── form_states.dart
            ├── pages/
            │   ├── login_page.dart
            │   ├── signup_page.dart
            │   └── reset_password_page.dart
            └── widgets/
                ├── auth_form.dart
                └── social_login_buttons.dart

## Layer Responsibilities

### Domain Layer (Business Logic)
- **Repositories (Interfaces)**: Define contracts for data operations
- **Use Cases**: Contain application business rules, orchestrate repository calls

### Data Layer (Implementation)
- **Models**: Data transfer objects that convert between API and domain entities
- **Data Sources**: Handle API calls (Supabase) and local storage
- **Repositories (Implementations)**: Implement domain repository interfaces using data sources

### Presentation Layer (UI)
- **Controllers/State Management**: Riverpod providers that manage UI state and call use cases
- **Pages**: Screen widgets that display UI and handle user interactions
- **Widgets**: Reusable UI components

## Supabase Integration Points

### Authentication Methods Needed:
1. Email/Password Sign Up
2. Email/Password Sign In  
3. Sign Out
4. Password Reset
5. Get Current User Session
6. Update User Profile

## Supabase Data Source Methods
- signUpWithEmailPassword(email, password)
- signInWithEmailPassword(email, password)
- signOut()
- sendPasswordResetEmail(email)
- getCurrentUser()
- updateUser(userData)

## Models
```dart
// user_model.dart
class UserModel {
  final String id;
  final String email;
  final String? displayName;
  final String? avatarUrl;
  final bool emailVerified;
  final DateTime createdAt;
  
  UserModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        email = json['email'],
        displayName = json['user_metadata']['full_name'],
        avatarUrl = user.avatar_url,
        emailVerified = email_confirmed_at != null,
        createdAt = DateTime.parse(json['created_at']);
  
  UserEntity toEntity() => UserEntity(
        id: id,
        email: email,
        displayName: displayName,
        avatarUrl: avatarUrl,
        emailVerified: emailVerified,
        createdAt: createdAt,
      );
}
```

## Repository Interface
```dart
// auth_repository.dart
abstract class AuthRepository {
  Future<UserEntity> signInWithEmail(String email, String password);
  Future<UserEntity> signUpWithEmail(String email, String password);
  Future<void> signOut();
  Future<void> resetPassword(String email);
  Future<UserEntity?> getCurrentUser();
  Future<UserEntity> updateUserProfile(String displayName);
}
```

## Riverpod Providers
```dart
// auth_controller.dart
final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(
    signInUseCase: ref.read(signInUseCaseProvider),
    signUpUseCase: ref.read(signUpUseCaseProvider),
    signOutUseCase: ref.read(signOutUseCaseProvider),
    resetPasswordUseCase: ref.read(resetPasswordUseCaseProvider),
    getCurrentUserUseCase: ref.read(getCurrentUserUseCaseProvider),
    updateUserProfileUseCase: ref.read(updateUserProfileUseCaseProvider),
  );
});

// States
class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final UserEntity? user;
  final String? errorMessage;
  
  AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.user,
    this.errorMessage,
  });
  
  AuthState copyWith({...}) => ...;
}
```

## Routes Integration
Add to app_router.dart:
```dart
static const String loginPath = '/auth/login';
static const String signupPath = '/auth/signup';
static const String resetPasswordPath = '/auth/reset-password';

// In routes:
GoRoute(
  path: loginPath,
  builder: (context, state) => const LoginPage()),
```

GoRoute(
  path: signupPath,
  builder: (context, state) => const SignUpPage(),
),
GoRoute(
  path: resetPasswordPath,
  builder: (context, state) => const ResetPasswordPage(),
),
```

## Security Considerations
- Use Supabase RLS (Row Level Security) for data protection
- Never store plain passwords or tokens in local storage
- Use secure storage for refresh tokens if needed
- Validate all inputs client-side and server-side
- Implement rate limiting for auth attempts

## Implementation Order
1. Set up Supabase client initialization
2. Create data models and data sources
3. Implement repository interfaces and implementations
4. Create use cases
5. Set up Riverpod providers and state management
6. Build UI pages and widgets
7. Integrate with app router
8. Add form validation and error handling
9. Write unit and widget tests
10. Handle edge cases (network errors, invalid tokens, etc.)