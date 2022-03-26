import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moderate_project/constants.dart';
import 'package:moderate_project/services/auth/auth_exceptions.dart';
import 'package:moderate_project/services/bloc/auth_event.dart';

import '../services/bloc/auth_bloc.dart';
import '../services/bloc/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  static const String id = "registerPage";

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(context: context, text: "Weak Password!!");
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(
                context: context, text: "Email already in use!!");
          } else if (state.exception is InValidEmailAuthException) {
            await showErrorDialog(context: context, text: "Email is invalid!!");
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
                context: context, text: "Registration Error!!");
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Register"),
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
                      .add(AuthEventRegister(_email.text, _password.text));
                },
                text: "Register",
                normal: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
