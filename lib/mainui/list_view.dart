import 'package:flutter/material.dart';
import 'package:moderate_project/screens/new_note.dart';
import 'package:moderate_project/services/cloud/cloud_note.dart';
import 'package:moderate_project/services/cloud/cloud_service.dart';
import '../constants.dart';

class MyListView extends StatelessWidget {
  final Iterable<CloudNote> list;

  const MyListView({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        if (list.elementAt(index).text.isNotEmpty) {
          return Card(
            child: ListTile(
              onTap: () {
                Navigator.pushNamed(context, NewNote.id,
                    arguments: list.elementAt(index));
              },
              leading: Text(
                (index + 1).toString(),
                textScaleFactor: 1.3,
              ),
              title: Text(
                list.elementAt(index).text,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 18, letterSpacing: 1.2),
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
                    FirebaseCloudStorage().deleteNote(
                        documentId: list.elementAt(index).documentId);
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
