import 'package:flutter/foundation.dart' show immutable;
import 'package:moderate_project/services/auth/auth_user.dart';

@immutable
abstract class AuthState {
  final bool isLoading;
  final String text;
  const AuthState({
    required this.isLoading,
    this.text = "Please wait a momenet..",
  });
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;
  const AuthStateRegistering({
    required this.exception,
    required bool isLoading,
    required String text,
  }) : super(isLoading: isLoading, text: text);
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn({required this.user, required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateNeedVerification extends AuthState {
  const AuthStateNeedVerification({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateLoggingIn extends AuthState {
  final Exception? exception;
  const AuthStateLoggingIn({
    required this.exception,
    required bool isLoading,
    required String text,
  }) : super(isLoading: isLoading, text: text);
}

class AuthStateForgotPassword extends AuthState {
  final Exception? exception;
  final bool hasSentEmail;

  const AuthStateForgotPassword({
    required this.exception,
    required this.hasSentEmail,
    required bool isLoading,
  }) : super(isLoading: isLoading);
}

class AuthStateLoggedOut extends AuthState {
  final Exception? exception;
  const AuthStateLoggedOut(
      {required this.exception, required String text, required bool isLoading})
      : super(isLoading: isLoading, text: text);
}
