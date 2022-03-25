import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moderate_project/services/cloud/cloud_storage_constants.dart';

class CloudNote {
  final String documentId;
  final String ownerUserId;
  final String text;

  const CloudNote({
    required this.documentId,
    required this.ownerUserId,
    required this.text,
  });

  factory CloudNote.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
    return CloudNote(
      documentId: snapshot.id,
      ownerUserId: snapshot.data()[ownerUserIdFieldName] as String,
      text: snapshot.data()[textFieldName] as String,
    );
  }
}
