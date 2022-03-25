import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/cupertino.dart';

@immutable
class AuthUser {
  final String id;
  final bool isEmailverified;
  final String email;
  const AuthUser(this.isEmailverified, this.email, this.id);

  factory AuthUser.fromFirebase(User user) {
    return AuthUser(user.emailVerified, user.email!, user.uid);
  }
}
