import 'package:flutter/material.dart';
import 'package:moderate_project/mainUI/homeui.dart';
import 'package:moderate_project/screens/homescreen.dart';
import 'package:moderate_project/screens/login.dart';
import 'package:moderate_project/screens/new_note.dart';
import 'package:moderate_project/screens/register.dart';
import 'package:moderate_project/screens/verification.dart';
import 'package:moderate_project/services/auth/auth_service.dart';

void main() async {
  await AuthService.fromFirebase().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      initialRoute: AuthService.fromFirebase().currentuser != null
          ? HomeUI.id
          : HomeScreen.id,
      routes: {
        RegisterPage.id: (context) => const RegisterPage(),
        LoginPage.id: (context) => const LoginPage(),
        Verification.id: (context) => const Verification(),
        HomeScreen.id: (context) => const HomeScreen(),
        HomeUI.id: (context) => const HomeUI(),
        NewNote.id: (context) => const NewNote(),
      },
    );
  }
}
