import 'package:flutter/material.dart';
import 'package:get/get.dart';

typedef DialogOptionBuilder<T> = Map<String, T?> Function();

class MyButton extends StatelessWidget {
  final Function() onPress;
  final String text;
  final bool normal;
  final BuildContext context;

  const MyButton({
    Key? key,
    required this.onPress,
    required this.text,
    required this.normal,
    required this.context,
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
      textColor: Colors.white,
      color: Get.isDarkMode ? Colors.tealAccent : Colors.lightBlueAccent,
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
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
            context: context,
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

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Password Reset',
    content:
        "We have sent you a password reset link. Please check you email for more information",
    optionBuilder: () => {
      'OK': null,
    },
  );
}

@immutable
class NormalTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType inputType;
  final String? Function(String?)? validator;
  const NormalTextField(
      {Key? key,
      required this.controller,
      required this.inputType,
      required this.labelText,
      required this.validator})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autocorrect: false,
      autofocus: true,
      obscureText: labelText == "Password" ? true : false,
      keyboardType: inputType,
      style: const TextStyle(
        color: Colors.black,
      ),
      cursorColor: Colors.black,
      maxLines: inputType == TextInputType.multiline ? 6 : 1,
      minLines: inputType == TextInputType.multiline ? 3 : 1,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Colors.lightBlueAccent,
        ),
        fillColor: Colors.grey,
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 2.0),
          borderRadius: BorderRadius.circular(25.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 2.0),
          borderRadius: BorderRadius.circular(25.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.purpleAccent, width: 2.0),
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
  }
}
