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
import 'package:frinkels/features/auth/domain/usecases/get_current_user.dart'
    as get_current_user;
import 'package:frinkels/features/auth/domain/usecases/no_params.dart';
import 'package:frinkels/core/failures/failure.dart';

import 'user_repository_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  late MockUserRepository mockUserRepository;
  late SignUp signUpUseCase;
  late SignIn signInUseCase;
  late sign_out.SignOut signOutUseCase;
  late get_current_user.GetCurrentUser getCurrentUserUseCase;

  const testEmail = 'test@example.com';
  const testPassword = 'password123';
  const testName = 'Test User';
  final testUser = User(
    id: '1',
    email: testEmail,
    name: testName,
    createdAt: DateTime(2022, 1, 1),
  );

  setUp(() {
    mockUserRepository = MockUserRepository();
    signUpUseCase = SignUp(mockUserRepository);
    signInUseCase = SignIn(mockUserRepository);
    signOutUseCase = sign_out.SignOut(mockUserRepository);
    getCurrentUserUseCase = get_current_user.GetCurrentUser(mockUserRepository);
  });

  group('SignUp UseCase', () {
    test('should call repository signUp method', () async {
      // arrange
      when(
        mockUserRepository.signUp(
          email: anyNamed('email'),
          password: anyNamed('password'),
          name: anyNamed('name'),
        ),
      ).thenAnswer((_) async => Right<Failure, User>(testUser));

      // act
      final result = await signUpUseCase.call(
        SignUpParams(email: testEmail, password: testPassword, name: testName),
      );

      // assert
      expect(result, equals(Right<Failure, User>(testUser)));
      verify(
        mockUserRepository.signUp(
          email: testEmail,
          password: testPassword,
          name: testName,
        ),
      );
      verifyNoMoreInteractions(mockUserRepository);
    });

    test('should return Failure when signUp fails', () async {
      // arrange
      when(
        mockUserRepository.signUp(
          email: anyNamed('email'),
          password: anyNamed('password'),
          name: anyNamed('name'),
        ),
      ).thenAnswer((_) async => Left<Failure, User>(ServerFailure()));

      // act
      final result = await signUpUseCase.call(
        SignUpParams(email: testEmail, password: testPassword, name: testName),
      );

      // assert
      expect(result, isA<Left<Failure, User>>());
      verify(
        mockUserRepository.signUp(
          email: testEmail,
          password: testPassword,
          name: testName,
        ),
      );
      verifyNoMoreInteractions(mockUserRepository);
    });
  });

  group('SignIn UseCase', () {
    test('should call repository signIn method', () async {
      // arrange
      when(
        mockUserRepository.signIn(any, any),
      ).thenAnswer((_) async => Right<Failure, User>(testUser));

      // act
      final result = await signInUseCase.call(
        SignInParams(email: testEmail, password: testPassword),
      );

      // assert
      expect(result, equals(Right<Failure, User>(testUser)));
      verify(mockUserRepository.signIn(testEmail, testPassword));
      verifyNoMoreInteractions(mockUserRepository);
    });
  });

  group('SignOut UseCase', () {
    test('should call repository signOut method', () async {
      // arrange
      when(
        mockUserRepository.signOut(),
      ).thenAnswer((_) async => Right<Failure, void>(null));

      // act
      final result = await signOutUseCase.call(NoParams());

      // assert
      expect(result, equals(Right<Failure, void>(null)));
      verify(mockUserRepository.signOut());
      verifyNoMoreInteractions(mockUserRepository);
    });
  });

  group('get_current_user.GetCurrentUser UseCase', () {
    test('should call repository getCurrentUser method', () async {
      // arrange
      when(
        mockUserRepository.getCurrentUser(),
      ).thenAnswer((_) async => Right<Failure, User>(testUser));

      // act
      final result = await getCurrentUserUseCase.call(
        NoParams(),
      );

      // assert
      expect(result, equals(Right<Failure, User>(testUser)));
      verify(mockUserRepository.getCurrentUser());
      verifyNoMoreInteractions(mockUserRepository);
    });
  });
}
