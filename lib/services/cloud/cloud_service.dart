import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moderate_project/services/cloud/cloud_exceptions.dart';
import 'package:moderate_project/services/cloud/cloud_note.dart';
import 'package:moderate_project/services/cloud/cloud_storage_constants.dart';

class FirebaseCloudStorage {
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();

  factory FirebaseCloudStorage() => _shared;

  final notes = FirebaseFirestore.instance.collection('notes');

  Future<CloudNote> createNewNote({required String owneruserId}) async {
    final note = await notes.add({
      ownerUserIdFieldName: owneruserId,
      textFieldName: "",
    });

    return CloudNote(documentId: note.id, ownerUserId: owneruserId, text: "");
  }

  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await notes
          .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
          .get()
          .then(
            (value) => value.docs.map(
              (doc) {
                return CloudNote.fromSnapshot(doc);
              },
            ),
          );
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  Stream<Iterable<CloudNote>> allNotes({required String owneruserId}) {
    return notes.snapshots().map(
          (event) => event.docs
              .map((e) => CloudNote.fromSnapshot(e))
              .where((element) => element.ownerUserId == owneruserId),
        );
  }

  Future<void> updateNote(
      {required String documentId, required String text}) async {
    try {
      await notes.doc(documentId).update({textFieldName: text});
    } catch (e) {
      throw CouldNotUpdateNotesException();
    }
  }

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNotesException();
    }
  }
}
