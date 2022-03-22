import 'dart:developer' show log;
import 'package:flutter/material.dart';
import 'package:moderate_project/constants.dart';
import 'package:moderate_project/screens/homescreen.dart';
import 'package:moderate_project/services/auth/auth_service.dart';

enum MenuAction { logout }

class HomeUI extends StatefulWidget {
  const HomeUI({Key? key}) : super(key: key);
  static const String id = "homeui";

  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Notes"),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLog = await showLogoutDialog(context);
                  log(shouldLog.toString());

                  if (shouldLog) {
                    AuthService.fromFirebase().logOut();
                    Navigator.pushNamedAndRemoveUntil(
                        context, HomeScreen.id, (route) => false);
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuAction>(
                  child: Text("Log out"),
                  value: MenuAction.logout,
                ),
              ];
            },
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(10),
        child: Text("HI"),
      ),
    );
  }
}
