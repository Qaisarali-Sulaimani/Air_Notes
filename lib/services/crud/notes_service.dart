import 'dart:developer';
import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart'
    show MissingPlatformDirectoryException, getApplicationDocumentsDirectory;
import 'package:path/path.dart' show join;
import 'notes_exceptions.dart';

const dbName = "notes.db";
const noteTable = "note";
const userTable = "user";
const idColumn = "id";
const emailColumn = "email";
const userIdColumn = "user_id";
const textColumn = "text";
const isSyncColumn = "is_sync_with_cloud";
const createUsertable = '''CREATE TABLE IF NOT EXISTS "user" (
                          "id"	INTEGER,
                          "email"	TEXT UNIQUE,
                          PRIMARY KEY("id" AUTOINCREMENT)
                          );''';

const createNoteTable = '''CREATE TABLE "note" (
                          "id"	INTEGER NOT NULL,
                          "user_id"	INTEGER NOT NULL,
                          "text"	TEXT NOT NULL,
                          "is_sync_with_cloud"	INTEGER NOT NULL DEFAULT 0,
                          PRIMARY KEY("id" AUTOINCREMENT),
                          FOREIGN KEY("user_id") REFERENCES "user"("id")
                        );''';

class NoteService {
  Database? _db;

  Future<DatabaseNote> updateNote(
      {required DatabaseNote note, required String text}) async {
    // check
    final db = _getDatabaseOrThrow();
    await getNote(id: note.id);

    final updated = await db.update(noteTable, {
      textColumn: text,
      isSyncColumn: 0,
    });

    if (updated == 0) {
      throw CouldNotUpdateNote();
    }

    return await getNote(id: note.id);
  }

  Future<Iterable<DatabaseNote>> getAllNotes() async {
    final db = _getDatabaseOrThrow();
    final notes = await db.query(noteTable);

    return notes.map((note) => DatabaseNote.fromRow(note));
  }

  Future<DatabaseNote> getNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final note = await db.query(
      noteTable,
      where: 'id == ?',
      whereArgs: [id],
    );

    if (note.isEmpty) {
      throw CouldNotFindNote();
    } else {
      return DatabaseNote.fromRow(note.first);
    }
  }

  Future<int> deleteAllNotes() async {
    final db = _getDatabaseOrThrow();
    return await db.delete(noteTable);
  }

  Future<void> deleteNote({required int id}) async {
    final db = _getDatabaseOrThrow();

    final count = await db.delete(
      noteTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (count == 0) {
      throw CouldNotDeleteNote();
    }
  }

  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
    final db = _getDatabaseOrThrow();

    final dbUser = await getuser(email: owner.email);

    if (dbUser != owner) {
      throw CouldNotFindUser();
    }

    final noteid = await db.insert(noteTable, {
      userIdColumn: owner.id,
      textColumn: '',
      isSyncColumn: 1,
    });

    return DatabaseNote(
        id: noteid, userId: owner.id, text: '', isSyncWithCloud: true);
  }

  Future<DatabaseUser> getuser({required String email}) async {
    final db = _getDatabaseOrThrow();

    final results = await db.query(
      userTable,
      where: 'email = ?',
      limit: 1,
      whereArgs: [email.toLowerCase()],
    );

    if (results.isEmpty) {
      throw CouldNotFindUser();
    } else {
      return DatabaseUser.fromRow(results.first);
    }
  }

  Future<DatabaseUser> createuser({required String email}) async {
    final db = _getDatabaseOrThrow();

    final results = await db.query(
      userTable,
      where: 'email = ?',
      limit: 1,
      whereArgs: [email.toLowerCase()],
    );

    if (results.isNotEmpty) {
      throw UserAlreadyExists();
    }

    final userId = await db.insert(userTable, {
      emailColumn: email.toLowerCase(),
    });

    return DatabaseUser(id: userId, email: email);
  }

  Future<void> deleteUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final count = await db.delete(
      userTable,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );

    if (count != 1) {
      throw CouldNotDeleteUser();
    }
  }

  Database _getDatabaseOrThrow() {
    if (_db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return _db!;
    }
  }

  Future<void> close() async {
    final db = _getDatabaseOrThrow();
    await db.close();
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }

    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);

      final db = await openDatabase(dbPath);
      _db = db;

      // create user and note table;
      await db.execute(createUsertable);
      await db.execute(createNoteTable);
      // end;

    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    } catch (e) {
      log(e.toString());
    }
  }
}

@immutable
class DatabaseUser {
  final int id;
  final String email;

  const DatabaseUser({required this.id, required this.email});

  factory DatabaseUser.fromRow(Map<String, Object?> map) {
    return DatabaseUser(
        id: map[idColumn] as int, email: map[emailColumn] as String);
  }

  @override
  String toString() {
    return "Person with id = $id and email = $email";
  }

  @override
  bool operator ==(covariant DatabaseUser other) {
    return id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}

class DatabaseNote {
  final int id;
  final int userId;
  final String text;
  final bool isSyncWithCloud;

  DatabaseNote(
      {required this.id,
      required this.userId,
      required this.text,
      required this.isSyncWithCloud});

  factory DatabaseNote.fromRow(Map<String, Object?> map) {
    return DatabaseNote(
        id: map[idColumn] as int,
        userId: map[userIdColumn] as int,
        text: map[textColumn] as String,
        isSyncWithCloud: (map[isSyncColumn] as int) == 1 ? true : false);
  }

  @override
  String toString() {
    return "Note with id = $id and isSync = $isSyncWithCloud";
  }

  @override
  bool operator ==(covariant DatabaseNote other) {
    return id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
