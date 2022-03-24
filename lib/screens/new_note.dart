import 'package:flutter/material.dart';
import 'package:moderate_project/services/auth/auth_service.dart';
import 'package:moderate_project/services/crud/notes_service.dart';
import 'package:moderate_project/utilities/genericArgument.dart';

class NewNote extends StatefulWidget {
  const NewNote({Key? key}) : super(key: key);
  static const String id = "newNote";

  @override
  State<NewNote> createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {
  DatabaseNote? _note;
  late final NoteService _noteService;
  late final TextEditingController _controller;

  Future<DatabaseNote> createOrGetExisting(BuildContext context) async {
    final widgetNote = context.getArgument<DatabaseNote>();

    if (widgetNote != null) {
      _note = widgetNote;
      _controller.text = widgetNote.text;
      return widgetNote;
    }

    if (_note != null) {
      return _note!;
    }
    final email = AuthService.fromFirebase().currentuser!.email!;
    final user = await _noteService.getuser(email: email);
    return await _noteService.createNote(owner: user);
  }

  void _deleteNoteIfTextEmpty() async {
    final note = _note;

    if (_controller.text.isEmpty && note != null) {
      await _noteService.deleteNote(id: note.id);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;

    if (_controller.text.isNotEmpty && note != null) {
      await _noteService.updateNote(note: note, text: _controller.text);
    }
  }

  void _textControllerListener() async {
    final note = _note;

    if (note == null) {
      return;
    }

    final text = _controller.text;
    await _noteService.updateNote(note: note, text: text);
  }

  void _setupTextControllerListener() {
    _controller.removeListener(_textControllerListener);
    _controller.addListener(_textControllerListener);
  }

  @override
  void initState() {
    _controller = TextEditingController();
    _noteService = NoteService();
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder(
          future: createOrGetExisting(context),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                _note = snapshot.hasData ? snapshot.data as DatabaseNote : null;
                _setupTextControllerListener();
                return TextField(
                  autofocus: true,
                  controller: _controller,
                  keyboardType: TextInputType.multiline,
                  enableSuggestions: true,
                  maxLines: null,
                  decoration:
                      const InputDecoration(hintText: "Enter Note Details ..."),
                );
              default:
                return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
