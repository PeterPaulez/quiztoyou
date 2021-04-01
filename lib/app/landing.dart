import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiztoyou/app/home.dart';
import 'package:quiztoyou/app/sign_in/signIn.dart';
import 'package:quiztoyou/services/auth.dart';

class LandingPage extends StatelessWidget {
  final AuthBase auth;
  const LandingPage({Key? key, required this.auth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            return SignInPage(
              auth: auth,
            );
          }

          // Signed USER
          return HomePage(
            auth: auth,
          );
        }

        // While retrieving DATA
        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
