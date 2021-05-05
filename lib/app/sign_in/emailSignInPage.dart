import 'package:flutter/material.dart';
import 'package:quiztoyou/app/sign_in/emailSigInFormBloc.dart';

class EmailSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
        title: Text('Sign-in by E-mail'),
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Card(
            child: EmailSignInFormBloc.create(context),
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
