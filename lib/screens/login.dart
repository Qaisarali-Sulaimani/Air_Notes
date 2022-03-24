import 'package:flutter/material.dart';
import 'package:moderate_project/constants.dart';
import 'package:moderate_project/mainui/homeui.dart';
import 'package:moderate_project/services/auth/auth_exceptions.dart';
import 'package:moderate_project/screens/verification.dart';
import 'package:moderate_project/services/auth/auth_service.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const String id = "loginPage";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
        title: const Text("Login"),
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
                    show = !show;
                  });
                  try {
                    await AuthService.fromFirebase()
                        .logIn(email: _email.text, password: _password.text);

                    final nuser = AuthService.fromFirebase().currentuser;

                    if (!nuser!.isEmailverified) {
                      await AuthService.fromFirebase().sendEmailverification();
                      Navigator.pushNamed(context, Verification.id);
                    } else {
                      Navigator.pushNamedAndRemoveUntil(
                          context, HomeUI.id, (route) => false);
                    }
                  } on UserNotFoundAuthException {
                    await showErrorDialog(
                        context: context, text: "User not found!!");
                  } on WrongPasswordAuthException {
                    await showErrorDialog(
                        context: context, text: "Wrong Credentials!!");
                  } on GenericAuthException {
                    await showErrorDialog(
                        context: context, text: "Authentication Error!!");
                  } catch (e) {
                    await showErrorDialog(
                        context: context, text: "Something bad happened");
                  }
                  setState(() {
                    show = !show;
                  });
                },
                text: "Login",
                normal: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
