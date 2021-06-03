import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  /// FirestoreService used as singletone using just one instance for every request
  /// Instance invocation is secure and faster
  FirestoreService._();
  static final instance = FirestoreService._();

  Future<void> setData(
      {required String path, required Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('$path: $data');
    await reference.set(data);
  }

  Stream<List<T>> collectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentId) builder,
  }) {
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();

    /// This code is not important for the method it's just logging purpose
    snapshots.listen((snapshot) {
      int contador = 0;
      snapshot.docs.forEach((element) {
        contador = contador + 1;
        print('Data $contador: ${element.data()}');
      });
    });

    return snapshots.map((snapshot) => snapshot.docs
        .map((snapshot) => builder(
              snapshot.data(),
              snapshot.id,
            ))
        .toList());
  }
}
