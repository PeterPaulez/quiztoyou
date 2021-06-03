import 'package:quiztoyou/app/home/models/job.dart';
import 'package:quiztoyou/services/api_path.dart';
import 'package:quiztoyou/services/firestore.dart';

abstract class Database {
  Future<void> setJob(Job job);
  Stream<List<Job>?> jobsStream();
}

// Calling documents with DateTime
String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  final String uid;
  FirestoreDatabase({required this.uid});
  final _sevice = FirestoreService.instance;

  // setJob is creating or editing our job
  Future<void> setJob(Job job) => _sevice.setData(
        path: ApiPath.job(uid, job.id),
        data: job.toMap(),
      );

  Stream<List<Job>?> jobsStream() => _sevice.collectionStream(
        builder: (data, documentId) => Job.fromMap(data, documentId),
        path: ApiPath.jobs(uid),
      );
}
