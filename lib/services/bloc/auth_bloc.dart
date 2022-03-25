import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moderate_project/services/auth/auth_provider.dart';
import 'auth_state.dart';
import 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateUninitialized()) {
    //initialize
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentuser;

      if (user == null) {
        emit(const AuthStateLoggedOut(null));
      } else if (!user.isEmailverified) {
        emit(const AuthStateNeedVerification());
      } else {
        emit(AuthStateLoggedIn(user));
      }
    });

    // send Email verification
    on<AuthEventSendEmailverification>((event, emit) async {
      await provider.sendEmailverification();
      emit(state);
    });

    // Event Register
    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;

      try {
        await provider.createUser(email: email, password: password);
        await provider.sendEmailverification();
        emit(const AuthStateNeedVerification());
      } on Exception catch (e) {
        emit(AuthStateRegistering(e));
      }
    });

    // login
    on<AuthEventLogin>((event, emit) async {
      final email = event.email;
      final password = event.password;

      try {
        final user = await provider.logIn(email: email, password: password);

        if (user.isEmailverified) {
          emit(AuthStateLoggedIn(user));
        } else {
          emit(const AuthStateNeedVerification());
        }
      } on Exception catch (e) {
        emit(AuthStateLoggingIn(e));
      }
    });

    //logout
    on<AuthEventLogout>((event, emit) async {
      try {
        await provider.logOut();
        emit(const AuthStateLoggedOut(null));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(e));
      }
    });

    on<AuthEventShouldRegister>((event, emit) {
      emit(const AuthStateRegistering(null));
    });

    on<AuthEventShouldLogin>((event, emit) {
      emit(const AuthStateLoggingIn(null));
    });
  }
}
