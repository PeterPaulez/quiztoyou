import 'package:quiztoyou/app/home/models/job.dart';
import 'package:quiztoyou/services/api_path.dart';
import 'package:quiztoyou/services/firestore.dart';

abstract class Database {
  Future<void> createJob(Job job);
  Stream<List<Job>?> jobsStream();
}

// Calling documents with DateTime
String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  final String uid;
  FirestoreDatabase({required this.uid});
  final _sevice = FirestoreService.instance;

  Future<void> createJob(Job job) => _sevice.setData(
        path: ApiPath.job(uid, documentIdFromCurrentDate()),
        data: job.toMap(),
      );

  Stream<List<Job>?> jobsStream() => _sevice.collectionStream(
        builder: (data) => Job.fromMap(data),
        path: ApiPath.jobs(uid),
      );
}
