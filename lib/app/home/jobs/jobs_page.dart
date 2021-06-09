import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiztoyou/app/home/jobs/empty_content.dart';
import 'package:quiztoyou/app/home/jobs/jobs_list_tile.dart';
import 'package:quiztoyou/app/home/jobs/job_page_detail.dart';
import 'package:quiztoyou/app/home/jobs/list_items_builder.dart';
import 'package:quiztoyou/app/home/models/job.dart';
import 'package:quiztoyou/common_widgets/dialog.dart';
import 'package:quiztoyou/services/auth.dart';
import 'package:quiztoyou/services/database.dart';

class JobsPage extends StatelessWidget {
  void _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
      print('LogOUT');
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await TextDialog.alert(
      context,
      title: 'Logout',
      content: 'Are you sure that you want to logout?',
      textOK: 'Logout',
      textNOK: 'Cancel',
    );
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    User? _user = FirebaseAuth.instance.currentUser;
    //final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () => _confirmSignOut(context),
          ),
        ],
        title: Column(
          children: [
            Text('Jobs'),
            Text(
              '${_user?.uid}',
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
          ],
        ),
      ),
      body: _buildContents(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        //onPressed: () => _createJob(context),
        onPressed: () => JobPageDetail.show(context),
        elevation: 0,
      ),
    );
  }

  _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Job>?>(
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        bool testing = false;
        if (testing) {
          return ListItemsBuilder<Job>(
            snapshot: snapshot,
            itemBuilder: (context, job) => JobsListTile(
              job: job,
              onTap: () => JobPageDetail.show(context, job: job),
            ),
          );
        } else {
          if (snapshot.hasData) {
            final jobs = snapshot.data!;
            if (jobs.isNotEmpty) {
              final children = jobs
                  .map(
                    (job) => JobsListTile(
                      job: job,
                      onTap: () => JobPageDetail.show(context, job: job),
                    ),
                  )
                  .toList();
              return ListView(children: children);
            }
            return EmptyContent(
              title: 'There is not content',
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text('Some error occurred'));
          }
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  /*
  Future<void> _createJob(BuildContext context) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.createJob(Job(name: 'Developing', ratePerHour: 10));
    } on FirebaseException catch (e) {
      ShowExceptionDialog.alert(
          context: context, title: 'Operation failed', exception: e);
    } catch (e) {
      TextDialog.alert(
        context,
        title: 'Operation Failed',
        content: e.toString(),
        textOK: 'Try again!',
      );
    }
  }
  */
}
