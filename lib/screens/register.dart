import 'package:flutter/material.dart';
import 'dart:developer' show log;
import 'package:moderate_project/constants.dart';
import 'package:moderate_project/screens/verification.dart';
import 'package:moderate_project/services/auth/auth_service.dart';
import 'package:moderate_project/services/auth/auth_exceptions.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  static const String id = "registerPage";

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool show = false;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: ModalProgressHUD(
        inAsyncCall: show,
        child: Padding(
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
                onPress: () async {
                  setState(() {
                    show = true;
                  });
                  try {
                    final user = await AuthService.fromFirebase().createUser(
                        email: _email.text, password: _password.text);
                    log(user.toString());

                    await AuthService.fromFirebase().sendEmailverification();
                    Navigator.pushNamed(context, Verification.id);
                  } on WeakPasswordAuthException {
                    await showErrorDialog(
                        context: context, text: "Weak Password!!");
                  } on EmailAlreadyInUseAuthException {
                    await showErrorDialog(
                        context: context, text: "Email already in use!!");
                  } on InValidEmailAuthException {
                    await showErrorDialog(
                        context: context, text: "Email is invalid!!");
                  } on GenericAuthException {
                    await showErrorDialog(
                        context: context, text: "Registration Error!!");
                  } catch (e) {
                    await showErrorDialog(
                        context: context, text: "Something bad happened!!");
                  }
                  setState(() {
                    show = false;
                  });
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
