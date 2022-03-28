import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moderate_project/constants.dart';
import 'package:moderate_project/services/auth/auth_exceptions.dart';
import 'package:moderate_project/services/bloc/auth_event.dart';

import '../services/bloc/auth_bloc.dart';
import '../services/bloc/auth_state.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail && state.exception == null) {
            _controller.clear();
            await showPasswordResetSentDialog(context);
            return;
          }

          if (state.exception is GenericAuthException) {
            if (_controller.text.isEmpty) {
              await showErrorDialog(
                context: context,
                text: 'Please enter email first.',
              );
            } else {
              await showErrorDialog(
                context: context,
                text:
                    'Please make sure your email is already registered. If not then register yourself.',
              );
            }
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Password Reset'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const Text(
                'Simply enter your email to get password email reset link.',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _controller,
                autocorrect: false,
                autofocus: true,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: 'Enter your email'),
              ),
              const SizedBox(
                height: 10,
              ),
              MyButton(
                onPress: () {
                  context
                      .read<AuthBloc>()
                      .add(AuthEventForgotPassword(_controller.text));
                },
                text: "Send reset link",
                normal: true,
                context: context,
              ),
              const SizedBox(
                height: 10,
              ),
              MyButton(
                onPress: () {
                  context.read<AuthBloc>().add(const AuthEventShouldLogin());
                },
                text: "Back to Login page",
                normal: true,
                context: context,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
