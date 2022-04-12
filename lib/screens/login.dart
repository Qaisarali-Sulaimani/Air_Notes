// ignore_for_file: deprecated_member_use

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
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

  Color get getMyColor {
    if (Get.isDarkMode) {
      return Theme.of(context).colorScheme.surface;
    } else {
      return Theme.of(context).colorScheme.primary;
    }
  }

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
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: Container(
          color: getMyColor,
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TyperAnimatedTextKit(
                        isRepeatingAnimation: false,
                        curve: Curves.linear,
                        speed: const Duration(milliseconds: 180),
                        text: const ['Login'],
                        textStyle: TextStyle(
                          fontSize: 45.0,
                          fontWeight: FontWeight.w900,
                          color: Theme.of(context).colorScheme.secondary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  NormalTextField(
                    controller: _email,
                    inputType: TextInputType.emailAddress,
                    labelText: "Email",
                    validator: null,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  NormalTextField(
                    controller: _password,
                    inputType: TextInputType.visiblePassword,
                    labelText: "Password",
                    validator: null,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MyButton(
                    onPress: () {
                      context.read<AuthBloc>().add(AuthEventLogin(
                          _email.text.trimRight(), _password.text.trimRight()));
                    },
                    text: "Login",
                    normal: true,
                    context: context,
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
                    context: context,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
