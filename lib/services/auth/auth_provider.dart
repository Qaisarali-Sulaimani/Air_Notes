import 'auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currentuser;

  Future<void> initialize();

  Future<AuthUser> logIn({
    required String email,
    required String password,
  });

  Future<AuthUser> createUser({
    required String email,
    required String password,
  });

  Future<void> sendPasswordReset({required String email});

  Future<void> logOut();

  Future<void> sendEmailverification();
}
