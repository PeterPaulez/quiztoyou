import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiztoyou/app/home.dart';
import 'package:quiztoyou/app/sign_in/signIn.dart';
import 'package:quiztoyou/services/auth.dart';

class LandingPage extends StatefulWidget {
  final AuthBase auth;
  const LandingPage({Key? key, required this.auth}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _updateUser(widget.auth.currentUser);
  }

  void _updateUser(User? user) {
    setState(() {
      _user = user;
      if (_user != null) {
        print('UID ${_user?.uid}');
      } else {
        print('UID nullValue');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return SignInPage(
        onSignIn: (user) => _updateUser(user),
        auth: widget.auth,
      );
    }

    return HomePage(
      onSignOut: () => _updateUser(null),
      auth: widget.auth,
    );
  }
}
