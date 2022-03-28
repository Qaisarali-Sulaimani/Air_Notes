import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:moderate_project/constants.dart';
import 'package:moderate_project/screens/new_note.dart';
import 'package:moderate_project/services/auth/auth_service.dart';
import 'package:moderate_project/services/bloc/auth_bloc.dart';
import 'package:moderate_project/services/bloc/auth_event.dart';
import 'package:moderate_project/services/cloud/cloud_note.dart';
import 'package:moderate_project/services/cloud/cloud_service.dart';
import 'list_view.dart';

extension Count<T extends Iterable> on Stream<T> {
  Stream<int> get getLength {
    return map((event) => event.length);
  }
}

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

  Color get getMyColor {
    if (Get.isDarkMode) {
      return Theme.of(context).colorScheme.surface;
    } else {
      return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  void initState() {
    _noteService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, NewNote.id);
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Your Notes"),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              await Future.delayed(const Duration(milliseconds: 250));
              Get.isDarkMode
                  ? Get.changeTheme(ThemeData.light())
                  : Get.changeTheme(ThemeData.dark());
            },
            icon: !Get.isDarkMode
                ? const Icon(Icons.dark_mode_outlined)
                : const Icon(Icons.light_mode),
          ),
          IconButton(
            onPressed: () async {
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
              if (shouldLog) {
                context.read<AuthBloc>().add(const AuthEventLogout());
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
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
          child: StreamBuilder<int>(
            stream: _noteService.allNotes(owneruserId: userId).getLength,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data as int >= 1) {
                  return StreamBuilder(
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
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        default:
                          return const Center(
                              child: CircularProgressIndicator());
                      }
                    },
                  );
                } else {
                  return const Center(
                    child: Text(
                      "Try Adding Some Notes",
                      style: TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1.2,
                      ),
                    ),
                  );
                }
              } else {
                return const Center(
                  child: Text(
                    "Try Adding Some Notes",
                    style: TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.2,
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
