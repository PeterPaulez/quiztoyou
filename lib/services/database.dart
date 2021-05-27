import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiztoyou/app/home/models/job.dart';
import 'package:quiztoyou/services/api_path.dart';

abstract class Database {
  Future<void> createJob(Job job);
  Stream<List<Job>?> jobsStream();
}

class FirestoreDatabase implements Database {
  final String uid;
  FirestoreDatabase({required this.uid});

  Future<void> createJob(Job job) => _setData(
        path: ApiPath.job(uid, 'job_abc'),
        data: job.toMap(),
      );

  Stream<List<Job>?> jobsStream() {
    final path = ApiPath.jobs(uid);
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();
    snapshots.listen((snapshot) {
      int contador = 0;
      snapshot.docs.forEach((element) {
        contador = contador + 1;
        print('Data $contador: ${element.data()}');
      });
    });

    return snapshots.map((snapshot) => snapshot.docs
        .map(
          (snapshot) => Job.fromMap(snapshot.data()),
          /*
          {
            final data = snapshot.data();
            return Job(
              name: data['name'],
              ratePerHour: data['ratePerHour'],
            );
          }
          ,
          */
        )
        .toList());
  }

  Future<void> _setData(
      {required String path, required Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('$path: $data');
    await reference.set(data);
  }
}
