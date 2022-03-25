import 'package:flutter/material.dart';
import 'package:moderate_project/constants.dart';
import 'package:moderate_project/services/auth/auth_service.dart';
import 'package:moderate_project/services/cloud/cloud_note.dart';
import 'package:moderate_project/services/cloud/cloud_service.dart';
import 'package:moderate_project/utilities/generic_argument.dart';
import 'package:share_plus/share_plus.dart';

class NewNote extends StatefulWidget {
  const NewNote({Key? key}) : super(key: key);
  static const String id = "newNote";

  @override
  State<NewNote> createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {
  CloudNote? _note;
  late final FirebaseCloudStorage _noteService;
  late final TextEditingController _controller;

  Future<CloudNote> createOrGetExisting(BuildContext context) async {
    final widgetNote = context.getArgument<CloudNote>();

    if (widgetNote != null) {
      _note = widgetNote;
      _controller.text = widgetNote.text;
      return widgetNote;
    }

    if (_note != null) {
      return _note!;
    }

    final userId = AuthService.fromFirebase().currentuser!.id;
    return _note = await _noteService.createNewNote(owneruserId: userId);
  }

  void _deleteNoteIfTextEmpty() async {
    final note = _note;

    if (_controller.text.isEmpty && note != null) {
      await _noteService.deleteNote(documentId: note.documentId);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;

    if (_controller.text.isNotEmpty && note != null) {
      await _noteService.updateNote(
          documentId: note.documentId, text: _controller.text);
    }
  }

  void _textControllerListener() async {
    final note = _note;

    if (note == null) {
      return;
    }

    await _noteService.updateNote(
        documentId: note.documentId, text: _controller.text);
  }

  void _setupTextControllerListener() {
    _controller.removeListener(_textControllerListener);
    _controller.addListener(_textControllerListener);
  }

  @override
  void initState() {
    _controller = TextEditingController();
    _noteService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  void dispose() {
    _deleteNoteIfTextEmpty();
    _saveNoteIfTextNotEmpty();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "New Note",
        ),
        actions: [
          IconButton(
            onPressed: () async {
              if (_controller.text.isEmpty) {
                await showCantShareEmptyNoteDialog(context);
              } else {
                Share.share(_controller.text);
              }
            },
            icon: const Icon(
              Icons.share,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder(
          future: createOrGetExisting(context),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                _note = snapshot.hasData ? snapshot.data as CloudNote : null;
                _setupTextControllerListener();
                return TextField(
                  autofocus: true,
                  controller: _controller,
                  keyboardType: TextInputType.multiline,
                  enableSuggestions: true,
                  style: const TextStyle(
                    letterSpacing: 1.3,
                    fontSize: 17,
                  ),
                  maxLines: null,
                  decoration:
                      const InputDecoration(hintText: "Enter Note Details ..."),
                );
              default:
                return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
