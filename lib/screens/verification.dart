import 'package:flutter/material.dart';
import 'package:moderate_project/constants.dart';
import 'package:moderate_project/screens/login.dart';
import 'package:moderate_project/services/auth/auth_service.dart';

class Verification extends StatefulWidget {
  const Verification({Key? key}) : super(key: key);
  static const String id = "verification";

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Email Verification"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const Text(
                "Please verify your email !!",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "A verification link is sent to your email. If not got then press resend button to resend!!",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              MyButton(
                onPress: () {
                  AuthService.fromFirebase().sendEmailverification();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Link is sent again to given email address!!",
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                text: "Resend",
                normal: true,
              ),
              const SizedBox(
                height: 10,
              ),
              MyButton(
                onPress: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, LoginPage.id, (route) => false);
                },
                text: "Restart",
                normal: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
