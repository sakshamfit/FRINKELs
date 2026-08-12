import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/controllers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/home/presentation/screens/post_screen.dart';
import '../../features/chat/presentation/screens/messages_list_screen.dart';
import '../../features/chat/presentation/screens/chat_screen.dart';
import '../../features/home/presentation/screens/profile_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/documentation/presentation/screens/documentation_screen.dart';
import '../../features/documentation/presentation/widgets/documentation_detail.dart';
import '../widgets/main_layout.dart';
import '../../features/auth/domain/entities/user.dart' as auth_user;

class AppRouter {
  static const String splashPath = '/splash';
  static const String onboardingPath = '/onboarding';
  static const String authPath = '/auth';
  static const String loginPath = '/auth/login';
  static const String signupPath = '/auth/signup';
  static const String homePath = '/';
  static const String searchPath = '/search';
  static const String postPath = '/post';
  static const String messagesPath = '/messages';
  static const String chatPath = '/chat';
  static const String profilePath = '/profile';
  static const String documentationPath = '/documentation';
  static const String documentationDetailPath = '/documentation/:id';

  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static GoRouter create(Ref ref) {
    final authController = ref.read(authControllerProvider);

    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: splashPath,
      redirect: (context, state) {
        final authState = ref.read(authControllerProvider).state;
        final loggedIn = authState.isAuthenticated;
        final isOnboarded = authState.user?.isOnboarded ?? false;

        debugPrint(
          'ROUTER: Redirect check - path: ${state.uri.path}, loggedIn: $loggedIn, isOnboarded: $isOnboarded',
        );

        final isAuthPath = state.uri.path.startsWith('/auth');
        final isSplashPath = state.uri.path == splashPath;
        final isOnboardingPath = state.uri.path == onboardingPath;

        if (loggedIn) {
          if (!isOnboarded && !isOnboardingPath) {
            debugPrint('ROUTER: Redirecting to onboarding');
            return onboardingPath;
          }
          if (isAuthPath || isSplashPath) {
            debugPrint('ROUTER: Redirecting to home');
            return homePath;
          }
        } else {
          if (!isAuthPath && !isSplashPath) {
            debugPrint('ROUTER: Redirecting to login');
            return '/auth/login';
          }
        }

        return null;
      },
      refreshListenable: authController,
      routes: [
        GoRoute(
          path: splashPath,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: onboardingPath,
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: '/auth/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/auth/signup',
          builder: (context, state) => const SignupScreen(),
        ),
        GoRoute(
          path: documentationPath,
          builder: (context, state) => const DocumentationScreen(),
        ),
        GoRoute(
          path: documentationDetailPath,
          builder: (context, state) => const DocumentationDetail(),
        ),
        GoRoute(
          path: chatPath,
          builder: (context, state) {
            final otherUser = state.extra as auth_user.User;
            return ChatScreen(otherUser: otherUser);
          },
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return MainLayout(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: homePath,
                  builder: (context, state) => const HomeScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: searchPath,
                  builder: (context, state) => const SearchScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: postPath,
                  builder: (context, state) => const PostScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: messagesPath,
                  builder: (context, state) => const MessagesListScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: profilePath,
                  builder: (context, state) => const ProfileScreen(),
                  routes: [
                    GoRoute(
                      path: ':userId',
                      builder: (context, state) {
                        final userId = state.pathParameters['userId'];
                        return ProfileScreen(userId: userId);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
