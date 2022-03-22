import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/cupertino.dart';

@immutable
class AuthUser {
  final bool isEmailverified;
  const AuthUser(this.isEmailverified);

  factory AuthUser.fromFirebase(User user) {
    return AuthUser(user.emailVerified);
  }
}
