import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> incrementCounter({
    required String collection,
    required String docId,
    required String field,
  }) async {
    try {
      final docRef = _firestore.collection(collection).doc(docId);
      await docRef.update({field: FieldValue.increment(1)});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> decrementCounter({
    required String collection,
    required String docId,
    required String field,
  }) async {
    try {
      final docRef = _firestore.collection(collection).doc(docId);
      await docRef.update({field: FieldValue.increment(-1)});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateField({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    try {
      final docRef = _firestore.collection(collection).doc(docId);
      await docRef.update(data);
    } catch (e) {
      rethrow;
    }
  }
}
