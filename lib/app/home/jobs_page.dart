import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      body: Center(
        child: Text('Jobs Page'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _createJob(context),
        elevation: 0,
      ),
    );
  }

  void _createJob(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    database.createJob(Job(
      name: 'Developing',
      ratePerHour: 10,
    ));
  }
}
