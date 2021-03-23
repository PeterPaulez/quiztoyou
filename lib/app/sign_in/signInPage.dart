import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
        title: Text('QuizToYou Sign-in'),
      ),
      body: Container(
        color: Colors.white,
      ),
    );
  }
}
