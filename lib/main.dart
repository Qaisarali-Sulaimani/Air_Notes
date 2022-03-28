import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:moderate_project/mainUI/homeui.dart';
import 'package:moderate_project/screens/forgot_password_view.dart';
import 'package:moderate_project/screens/homescreen.dart';
import 'package:moderate_project/screens/login.dart';
import 'package:moderate_project/screens/new_note.dart';
import 'package:moderate_project/screens/register.dart';
import 'package:moderate_project/screens/verification.dart';
import 'package:moderate_project/services/auth/firebase_auth_provider.dart';
import 'package:moderate_project/services/bloc/auth_bloc.dart';
import 'package:moderate_project/services/bloc/auth_event.dart';
import 'package:moderate_project/services/bloc/auth_state.dart';
import 'package:moderate_project/utilities/loading/loading_screen.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
        NewNote.id: (context) => const NewNote(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // initial
    context.read<AuthBloc>().add(const AuthEventInitialize());

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(context: context, text: state.text);
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const HomeUI();
        } else if (state is AuthStateNeedVerification) {
          return const Verification();
        } else if (state is AuthStateLoggedOut) {
          return const HomeScreen();
        } else if (state is AuthStateRegistering) {
          return const RegisterPage();
        } else if (state is AuthStateLoggingIn) {
          return const LoginPage();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPassword();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
