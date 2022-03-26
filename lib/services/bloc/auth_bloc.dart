import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moderate_project/services/auth/auth_exceptions.dart';
import 'package:moderate_project/services/auth/auth_provider.dart';
import 'auth_state.dart';
import 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(const AuthStateUninitialized(isLoading: true)) {
    //initialize
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentuser;

      if (user == null) {
        emit(const AuthStateLoggedOut(
            exception: null, isLoading: false, text: ''));
      } else if (!user.isEmailverified) {
        emit(const AuthStateNeedVerification(isLoading: false));
      } else {
        emit(AuthStateLoggedIn(isLoading: false, user: user));
      }
    });

    on<AuthEventForgotPassword>((event, emit) async {
      emit(const AuthStateForgotPassword(
          exception: null, hasSentEmail: false, isLoading: false));
      final email = event.email;

      if (email?.isEmpty ?? true) {
        emit(AuthStateForgotPassword(
            exception: InValidEmailAuthException as Exception,
            hasSentEmail: false,
            isLoading: false));
        return;
      }

      emit(const AuthStateForgotPassword(
          exception: null, hasSentEmail: false, isLoading: true));
      bool didSendEmail;
      Exception? exception;
      try {
        await provider.sendPasswordReset(email: email!);
        didSendEmail = true;
        exception = null;
      } on Exception catch (e) {
        didSendEmail = false;
        exception = e;
      }

      emit(AuthStateForgotPassword(
          exception: exception, hasSentEmail: didSendEmail, isLoading: false));
    });

    // send Email verification
    on<AuthEventSendEmailverification>((event, emit) async {
      await provider.sendEmailverification();
      emit(state);
    });

    // Event Register
    on<AuthEventRegister>((event, emit) async {
      emit(const AuthStateRegistering(
        exception: null,
        isLoading: true,
        text: 'Please wait while I register you..',
      ));
      final email = event.email;
      final password = event.password;

      try {
        await provider.createUser(email: email, password: password);
        await provider.sendEmailverification();
        emit(const AuthStateNeedVerification(isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateRegistering(exception: e, isLoading: false, text: ''));
      }
    });

    // login
    on<AuthEventLogin>((event, emit) async {
      emit(const AuthStateLoggingIn(
        exception: null,
        isLoading: true,
        text: 'Please wait while I log you in..',
      ));

      final email = event.email;
      final password = event.password;

      try {
        final user = await provider.logIn(email: email, password: password);

        if (user.isEmailverified) {
          emit(AuthStateLoggedIn(isLoading: false, user: user));
        } else {
          emit(const AuthStateNeedVerification(isLoading: false));
        }
      } on Exception catch (e) {
        emit(AuthStateLoggingIn(exception: e, isLoading: false, text: ''));
      }
    });

    //logout
    on<AuthEventLogout>((event, emit) async {
      try {
        await provider.logOut();
        emit(const AuthStateLoggedOut(
            exception: null, isLoading: false, text: ''));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e, isLoading: false, text: ''));
      }
    });

    on<AuthEventShouldRegister>((event, emit) {
      emit(const AuthStateRegistering(
        exception: null,
        isLoading: false,
        text: '',
      ));
    });

    on<AuthEventShouldLogin>((event, emit) {
      emit(const AuthStateLoggingIn(
        exception: null,
        isLoading: false,
        text: '',
      ));
    });
  }
}
