import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moderate_project/constants.dart';
import 'package:moderate_project/services/auth/auth_exceptions.dart';
import 'package:moderate_project/services/bloc/auth_event.dart';
import '../services/bloc/auth_bloc.dart';
import '../services/bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const String id = "loginPage";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggingIn) {
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(
                context: context,
                text: "Cannot find user with given credentials!!");
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(
                context: context, text: "Wrong Credentials!!");
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
                context: context, text: "Authentication Error!!");
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextField(
                controller: _email,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: "Enter Email",
                ),
              ),
              TextField(
                controller: _password,
                autocorrect: false,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Enter Password",
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              MyButton(
                onPress: () {
                  context
                      .read<AuthBloc>()
                      .add(AuthEventLogin(_email.text, _password.text));
                },
                text: "Login",
                normal: true,
              ),
              const SizedBox(
                height: 10,
              ),
              MyButton(
                onPress: () {
                  context
                      .read<AuthBloc>()
                      .add(const AuthEventForgotPassword(null));
                },
                text: "Forgot Password",
                normal: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
