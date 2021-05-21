import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiztoyou/app/home/models/job.dart';
import 'package:quiztoyou/services/api_path.dart';

abstract class Database {
  Future<void> createJob(Job job);
}

class FirestoreDatabase implements Database {
  final String uid;
  FirestoreDatabase({required this.uid});

  Future<void> createJob(Job job) => _setData(
        path: ApiPath.job(uid, 'job_abc'),
        data: job.toMap(),
      );

  Future<void> _setData(
      {required String path, required Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('$path: $data');
    await reference.set(data);
  }
}
