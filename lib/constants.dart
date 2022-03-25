import 'package:flutter/material.dart';

typedef DialogOptionBuilder<T> = Map<String, T?> Function();

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

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder optionBuilder,
}) {
  final options = optionBuilder();
  return showDialog<T>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: options.keys.map((optionTile) {
          final value = options[optionTile];
          return MyButton(
            onPress: () {
              if (value != null) {
                Navigator.of(context).pop(value);
              } else {
                Navigator.of(context).pop();
              }
            },
            text: optionTile,
            normal: true,
          );
        }).toList(),
      );
    },
  );
}

Future<void> showErrorDialog({
  required BuildContext context,
  required String text,
}) {
  return showGenericDialog(
    context: context,
    title: "An Error Occured",
    content: text,
    optionBuilder: () {
      return {
        'OK': null,
      };
    },
  );
}

Future<void> showCantShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: "Sharing",
    content: "You cannot share an empty note!",
    optionBuilder: () {
      return {
        'OK': null,
      };
    },
  );
}
