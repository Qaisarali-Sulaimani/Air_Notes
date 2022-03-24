import 'package:flutter/material.dart';
import 'package:moderate_project/screens/new_note.dart';
import '../constants.dart';
import '../services/crud/notes_service.dart';

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
              onTap: () {
                Navigator.pushNamed(context, NewNote.id,
                    arguments: list[index]);
              },
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
