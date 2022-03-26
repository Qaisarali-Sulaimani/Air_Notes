import 'package:moderate_project/services/auth/firebase_auth_provider.dart';

import 'auth_provider.dart';
import 'auth_user.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService(this.provider);

  factory AuthService.fromFirebase() {
    return AuthService(FirebaseAuthProvider());
  }

  @override
  Future<AuthUser> createUser(
      {required String email, required String password}) {
    return provider.createUser(email: email, password: password);
  }

  @override
  AuthUser? get currentuser {
    return provider.currentuser;
  }

  @override
  Future<AuthUser> logIn({required String email, required String password}) {
    return provider.logIn(email: email, password: password);
  }

  @override
  Future<void> logOut() {
    return provider.logOut();
  }

  @override
  Future<void> sendEmailverification() {
    return provider.sendEmailverification();
  }

  @override
  Future<void> initialize() {
    return provider.initialize();
  }

  @override
  Future<void> sendPasswordReset({required String email}) {
    return provider.sendEmailverification();
  }
}
