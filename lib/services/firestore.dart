import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lista_de_presentes/data/models/present.dart';

class FirestoreService {
  final CollectionReference presents = FirebaseFirestore.instance.collection('presents');

  Future<DocumentReference> addPresent(Present present) {
    return presents.add(present.toMap());
  }

  Stream<QuerySnapshot> getPresentsStream() {
    return presents.snapshots();
  }

  Future<void> updatePresent(String docID, Present present) {
    return presents.doc(docID).update(present.toMap());
  }

  Future<void> deletePresent(String docID) {
    return presents.doc(docID).delete();
  }
}