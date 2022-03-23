import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/cupertino.dart';

@immutable
class AuthUser {
  final bool isEmailverified;
  final String? email;
  const AuthUser(this.isEmailverified, this.email);

  factory AuthUser.fromFirebase(User user) {
    return AuthUser(user.emailVerified, user.email);
  }
}
