import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moderate_project/screens/new_note.dart';
import 'package:moderate_project/services/cloud/cloud_note.dart';
import 'package:moderate_project/services/cloud/cloud_service.dart';
import '../constants.dart';

class MyListView extends StatefulWidget {
  final Iterable<CloudNote> list;

  const MyListView({Key? key, required this.list}) : super(key: key);

  @override
  State<MyListView> createState() => _MyListViewState();
}

class _MyListViewState extends State<MyListView> {
  Color get getMyColor {
    if (Get.isDarkMode) {
      return Theme.of(context).colorScheme.surface;
    } else {
      return Theme.of(context).colorScheme.secondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.list.length,
      itemBuilder: (context, index) {
        if (widget.list.elementAt(index).text.isNotEmpty) {
          return Card(
            shape: const StadiumBorder(),
            color: getMyColor,
            child: ListTile(
              textColor: Colors.white,
              onTap: () {
                Navigator.pushNamed(context, NewNote.id,
                    arguments: widget.list.elementAt(index));
              },
              leading: Text(
                (index + 1).toString(),
                textScaleFactor: 1.3,
              ),
              title: Text(
                widget.list.elementAt(index).text,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 18, letterSpacing: 1.2),
              ),
              enableFeedback: true,
              trailing: IconButton(
                color: Colors.white,
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
                        documentId: widget.list.elementAt(index).documentId);
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
