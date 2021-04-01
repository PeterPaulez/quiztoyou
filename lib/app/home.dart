import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiztoyou/services/auth.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.auth}) : super(key: key);
  final AuthBase auth;

  void _signOut() async {
    try {
      await auth.signOut();
      print('LogOUT');
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    User? _user = FirebaseAuth.instance.currentUser;
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
          title: Text('Home Page'),
        ),
        body: Container(
          color: Colors.white,
          child: SafeArea(
            child: Text('Hola: ${_user?.uid}'),
          ),
        ));
  }
}
