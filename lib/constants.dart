import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function() onPress;
  final String text;
  final bool normal;

  const MyButton({
    Key? key,
    required this.onPress,
    required this.text,
    required this.normal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPress,
      shape: const StadiumBorder(),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
      height: 40,
      minWidth: normal ? double.infinity : null,
      color: Colors.blueAccent,
      textColor: Colors.white,
    );
  }
}

Future<bool> showLogoutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Sign Out"),
        content: const Text("Are you sure you want to sign out?"),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MyButton(
                onPress: () {
                  Navigator.of(context).pop(true);
                },
                text: "Log out",
                normal: false,
              ),
              MyButton(
                onPress: () {
                  Navigator.of(context).pop(false);
                },
                text: "Cancel",
                normal: false,
              ),
            ],
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}

Future<void> showError(BuildContext context, String text) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("An error occured!!"),
        content: Text(text),
        actions: [
          MyButton(
            onPress: () {
              Navigator.of(context).pop();
            },
            text: "OK",
            normal: false,
          ),
        ],
      );
    },
  );
}
