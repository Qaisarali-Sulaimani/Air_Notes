// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moderate_project/constants.dart';
import 'package:moderate_project/services/bloc/auth_event.dart';

import '../services/bloc/auth_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String id = "homeScreen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);

    animation = ColorTween(
      begin: const Color.fromARGB(255, 68, 167, 76),
      end: const Color.fromARGB(255, 85, 61, 192),
    ).animate(controller);

    controller.forward();

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TyperAnimatedTextKit(
                  isRepeatingAnimation: false,
                  curve: Curves.linear,
                  speed: const Duration(milliseconds: 180),
                  text: const ['Air Notes'],
                  textStyle: const TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            MyButton(
              onPress: () {
                context.read<AuthBloc>().add(const AuthEventShouldRegister());
              },
              text: "Register",
              normal: true,
            ),
            const SizedBox(
              height: 8.0,
            ),
            MyButton(
              onPress: () {
                context.read<AuthBloc>().add(const AuthEventShouldLogin());
              },
              text: "Login",
              normal: true,
            ),
          ],
        ),
      ),
    );
  }
}
