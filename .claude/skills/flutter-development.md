# Flutter Development Skill

## Purpose
Provides guidelines and best practices for Flutter development in the FRINKELS app.

## Guidelines
1. **State Management**: Use Riverpod for all state management needs
2. **Architecture**: Follow Clean Architecture principles with separation of concerns
3. **UI Components**: Reuse existing widgets from lib/core/widgets/ and feature-specific widgets
4. **Navigation**: Use GoRouter with the established routing patterns in lib/core/router/
5. **Error Handling**: Use the Either/Failure pattern from dartz for consistent error handling
6. **Testing**: Write unit tests for business logic and widget tests for UI components
7. **Performance**: Use const widgets where possible, avoid rebuilds in build() methods
8. **Platform Specifics**: Handle web, mobile, and desktop differences appropriately
9. **Dependencies**: Keep pubspec.yaml updated and run flutter pub get regularly
10. **Code Style**: Follow Dart effective Dart guidelines and use flutter_lints

## Common Patterns
- Use ConsumerWidget for widgets that need to access providers
- Use Ref.watch() and Ref.read() appropriately for provider access
- Use AsyncValue for handling loading/error/data states
- Use GoRouter for navigation with proper route guarding
- Use Supabase service for database operations
- Use FirebaseAuthService for authentication flows

## Commands
- flutter pub get - Get dependencies
- flutter run - Run the app
- flutter test - Run tests
- flutter build apk - Build Android APK
- flutter build ios - Build iOS IPA
- flutter build web - Build for web