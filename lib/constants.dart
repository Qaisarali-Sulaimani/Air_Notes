import 'package:flutter/material.dart';
import 'package:moderate_project/services/crud/notes_service.dart';

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

class MyListView extends StatelessWidget {
  final List<DatabaseNote> list;

  const MyListView({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        if (list[index].text.isNotEmpty) {
          return Card(
            child: ListTile(
              leading: Text(
                list[index].id.toString(),
              ),
              title: Text(
                list[index].text,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
              enableFeedback: true,
              trailing: IconButton(
                onPressed: () async {
                  final shouldDelete = await showGenericDialog(
                    context: context,
                    title: "Delete Note",
                    content: "Do you really want to delete this note?",
                    optionBuilder: () {
                      return {
                        "Delete": true,
                        "Cancel": false,
                      };
                    },
                  );

                  if (shouldDelete) {
                    NoteService().deleteNote(id: list[index].id);
                  }
                },
                icon: const Icon(Icons.delete),
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
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
