import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:frinkels/features/auth/domain/entities/user.dart';
import 'package:frinkels/features/auth/domain/repositories/user_repository.dart';
import 'package:frinkels/features/auth/domain/usecases/sign_up.dart';
import 'package:frinkels/features/auth/domain/usecases/sign_in.dart';
import 'package:frinkels/features/auth/domain/usecases/sign_out.dart'
    as sign_out;
import 'package:frinkels/features/auth/domain/usecases/reset_password.dart';
import 'package:frinkels/features/auth/domain/usecases/get_current_user.dart'
    as get_current_user;
import 'package:frinkels/features/auth/domain/usecases/update_user_profile.dart';
import 'package:frinkels/features/auth/domain/usecases/no_params.dart';
import 'package:frinkels/core/failures/failure.dart';

import 'auth_usecases_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  late MockUserRepository mockRepository;

  const testEmail = 'test@example.com';
  const testPassword = 'password123';
  final testUser = User(
    id: '1',
    email: testEmail,
    name: 'Test User',
    createdAt: DateTime(2022, 1, 1),
  );

  setUp(() {
    mockRepository = MockUserRepository();
  });

  group('SignUp UseCase', () {
    late SignUp useCase;

    setUp(() {
      useCase = SignUp(mockRepository);
    });

    test('should return User when signUp is successful', () async {
      // arrange
      when(
        mockRepository.signUp(
          email: anyNamed('email'),
          password: anyNamed('password'),
          name: anyNamed('name'),
        ),
      ).thenAnswer((_) async => Right<Failure, User>(testUser));

      // act
      final result = await useCase.call(
        const SignUpParams(
          email: testEmail,
          password: testPassword,
          name: 'Test User',
        ),
      );

      // assert
      expect(result, equals(Right<Failure, User>(testUser)));
      verify(
        mockRepository.signUp(
          email: testEmail,
          password: testPassword,
          name: 'Test User',
        ),
      );
    });

    test('should return Failure when signUp fails', () async {
      // arrange
      when(
        mockRepository.signUp(
          email: anyNamed('email'),
          password: anyNamed('password'),
          name: anyNamed('name'),
        ),
      ).thenAnswer((_) async => Left<Failure, User>(ServerFailure()));

      // act
      final result = await useCase.call(
        const SignUpParams(
          email: testEmail,
          password: testPassword,
          name: 'Test User',
        ),
      );

      // assert
      expect(result, isA<Left<Failure, User>>());
      verify(
        mockRepository.signUp(
          email: testEmail,
          password: testPassword,
          name: 'Test User',
        ),
      );
    });
  });

  group('SignIn UseCase', () {
    late SignIn useCase;

    setUp(() {
      useCase = SignIn(mockRepository);
    });

    test('should return User when signIn is successful', () async {
      // arrange
      when(
        mockRepository.signIn(any, any),
      ).thenAnswer((_) async => Right<Failure, User>(testUser));

      // act
      final result = await useCase.call(
        const SignInParams(email: testEmail, password: testPassword),
      );

      // assert
      expect(result, equals(Right<Failure, User>(testUser)));
      verify(mockRepository.signIn(testEmail, testPassword));
    });

    test('should return Failure when signIn fails', () async {
      // arrange
      when(
        mockRepository.signIn(any, any),
      ).thenAnswer((_) async => Left<Failure, User>(ServerFailure()));

      // act
      final result = await useCase.call(
        const SignInParams(email: testEmail, password: testPassword),
      );

      // assert
      expect(result, isA<Left<Failure, User>>());
      verify(mockRepository.signIn(testEmail, testPassword));
    });
  });

  group('sign_out.SignOut UseCase', () {
    late sign_out.SignOut useCase;

    setUp(() {
      useCase = sign_out.SignOut(mockRepository);
    });

    test('should return void when signOut is successful', () async {
      // arrange
      when(
        mockRepository.signOut(),
      ).thenAnswer((_) async => Right<Failure, void>(null));

      // act
      final result = await useCase.call(NoParams());

      // assert
      expect(result, equals(Right<Failure, void>(null)));
      verify(mockRepository.signOut());
    });

    test('should return Failure when signOut fails', () async {
      // arrange
      when(
        mockRepository.signOut(),
      ).thenAnswer((_) async => Left<Failure, void>(ServerFailure()));

      // act
      final result = await useCase.call(NoParams());

      // assert
      expect(result, isA<Left<Failure, void>>());
      verify(mockRepository.signOut());
    });
  });

  group('ResetPassword UseCase', () {
    late ResetPassword useCase;

    setUp(() {
      useCase = ResetPassword(mockRepository);
    });

    test('should return void when resetPassword is successful', () async {
      // arrange
      when(
        mockRepository.resetPassword(any),
      ).thenAnswer((_) async => Right<Failure, void>(null));

      // act
      final result = await useCase.call(
        const ResetPasswordParams(email: testEmail),
      );

      // assert
      expect(result, equals(Right<Failure, void>(null)));
      verify(mockRepository.resetPassword(testEmail));
    });

    test('should return Failure when resetPassword fails', () async {
      // arrange
      when(
        mockRepository.resetPassword(any),
      ).thenAnswer((_) async => Left<Failure, void>(ServerFailure()));

      // act
      final result = await useCase.call(
        const ResetPasswordParams(email: testEmail),
      );

      // assert
      expect(result, isA<Left<Failure, void>>());
      verify(mockRepository.resetPassword(testEmail));
    });
  });

  group('get_current_user.GetCurrentUser UseCase', () {
    late get_current_user.GetCurrentUser useCase;

    setUp(() {
      useCase = get_current_user.GetCurrentUser(mockRepository);
    });

    test('should return User when getCurrentUser is successful', () async {
      // arrange
      when(
        mockRepository.getCurrentUser(),
      ).thenAnswer((_) async => Right<Failure, User>(testUser));

      // act
      final result = await useCase.call(NoParams());

      // assert
      expect(result, equals(Right<Failure, User>(testUser)));
      verify(mockRepository.getCurrentUser());
    });

    test('should return null when no user is found', () async {
      // arrange
      when(
        mockRepository.getCurrentUser(),
      ).thenAnswer((_) async => Right<Failure, User?>(null));

      // act
      final result = await useCase.call(NoParams());

      // assert
      expect(result, equals(Right<Failure, User?>(null)));
      verify(mockRepository.getCurrentUser());
    });

    test('should return Failure when getCurrentUser fails', () async {
      // arrange
      when(
        mockRepository.getCurrentUser(),
      ).thenAnswer((_) async => Left<Failure, User?>(ServerFailure()));

      // act
      final result = await useCase.call(NoParams());

      // assert
      expect(result, isA<Left<Failure, User?>>());
      verify(mockRepository.getCurrentUser());
    });
  });

  group('UpdateUserProfile UseCase', () {
    late UpdateUserProfile useCase;

    setUp(() {
      useCase = UpdateUserProfile(mockRepository);
    });

    test('should return User when updateUserProfile is successful', () async {
      // arrange
      when(
        mockRepository.updateUserProfile(any),
      ).thenAnswer((_) async => Right<Failure, User>(testUser));

      // act
      final result = await useCase.call(
        const UpdateUserProfileParams(displayName: 'Updated Name'),
      );

      // assert
      expect(result, equals(Right<Failure, User>(testUser)));
      verify(mockRepository.updateUserProfile('Updated Name'));
    });

    test('should return Failure when updateUserProfile fails', () async {
      // arrange
      when(
        mockRepository.updateUserProfile(any),
      ).thenAnswer((_) async => Left<Failure, User>(ServerFailure()));

      // act
      final result = await useCase.call(
        const UpdateUserProfileParams(displayName: 'Updated Name'),
      );

      // assert
      expect(result, isA<Left<Failure, User>>());
      verify(mockRepository.updateUserProfile('Updated Name'));
    });
  });
}
