import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiztoyou/common_widgets/customButtom.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
        title: Text('QuizToYou Sign-in'),
        elevation: 2.0,
      ),
      body: _builContent(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _builContent() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Sign In',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 48),
          CustomButtom(
            text: 'Sign in with Google',
            onPressed: () {},
            icon: Icon(FontAwesomeIcons.google),
          ),
          SizedBox(height: 8),
          CustomButtom(
            text: 'Sign in with Apple',
            textColor: Colors.white,
            buttonColor: Colors.black87,
            onPressed: () {},
            icon: Icon(
              FontAwesomeIcons.apple,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          CustomButtom(
            text: 'Sign in with Facebook',
            textColor: Colors.white,
            buttonColor: Color(0xFF333D92),
            onPressed: () {},
            icon: Icon(
              FontAwesomeIcons.facebook,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          CustomButtom(
            text: 'Sign in with Email',
            textColor: Colors.white,
            onPressed: () {},
            buttonColor: Colors.teal[700],
            icon: Icon(
              FontAwesomeIcons.mailBulk,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'or',
            style: TextStyle(fontSize: 14, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          CustomButtom(
            text: 'Go anonymous',
            onPressed: () {},
            buttonColor: Colors.lime[300],
            icon: Icon(FontAwesomeIcons.glasses),
          ),
        ],
      ),
    );
  }
}
