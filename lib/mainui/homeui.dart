import 'dart:developer' show log;
import 'package:flutter/material.dart';
import 'package:moderate_project/constants.dart';
import 'package:moderate_project/screens/homescreen.dart';
import 'package:moderate_project/screens/new_note.dart';
import 'package:moderate_project/services/auth/auth_service.dart';
import 'package:moderate_project/services/cloud/cloud_note.dart';
import 'package:moderate_project/services/cloud/cloud_service.dart';
import 'list_view.dart';

enum MenuAction { logout }

class HomeUI extends StatefulWidget {
  const HomeUI({Key? key}) : super(key: key);
  static const String id = "homeui";

  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  late final FirebaseCloudStorage _noteService;

  String get userId {
    return AuthService.fromFirebase().currentuser!.id;
  }

  @override
  void initState() {
    _noteService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Notes"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, NewNote.id);
            },
            icon: const Icon(Icons.add),
            enableFeedback: true,
            splashRadius: 25,
          ),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLog = await showGenericDialog(
                    context: context,
                    title: "Sign Out",
                    content: "Do you really want to log out?",
                    optionBuilder: () {
                      return {
                        'Log Out': true,
                        'Cancel': false,
                      };
                    },
                  );
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
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: StreamBuilder(
          stream: _noteService.allNotes(owneruserId: userId),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final list = snapshot.data as Iterable<CloudNote>;
                  return MyListView(
                    list: list,
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              default:
                return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
