import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.onSignOut}) : super(key: key);
  final VoidCallback onSignOut;

  void _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      print('LogOUT');
      onSignOut();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    User _user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: _signOut,
            ),
          ],
          title: Text('Home'),
        ),
        body: Container(
          color: Colors.white,
          child: SafeArea(
            child: Text('Hola: ${_user.uid}'),
          ),
        ));
  }
}
