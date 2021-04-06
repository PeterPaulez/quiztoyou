import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiztoyou/app/sign_in/socialButton.dart';
import 'package:quiztoyou/services/auth.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({required this.auth});
  final AuthBase auth;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [],
        title: Text('QuizToYou Sign-in'),
        elevation: 2.0,
      ),
      body: _builContent(size),
      backgroundColor: Colors.grey[200],
    );
  }

  void _signInAnonymously() async {
    try {
      await auth.signInAnonymously();
      print('LogIn');
    } catch (e) {
      print(e.toString());
    }
  }

  void _signInGoogle() async {
    try {
      await auth.signInGoogle();
      print('LogIn');
    } catch (e) {
      print(e.toString());
    }
  }

  Widget _builContent(Size size) {
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
          SocialButton(
            size: size,
            text: 'Sign in with Google',
            onPressed: _signInGoogle,
            icon: Icon(FontAwesomeIcons.google),
          ),
          SizedBox(height: 8),
          SocialButton(
            size: size,
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
          SocialButton(
            size: size,
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
          SocialButton(
            size: size,
            text: 'Sign in with Email',
            textColor: Colors.white,
            onPressed: () {},
            buttonColor: Colors.teal.shade700,
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
          SocialButton(
            size: size,
            text: 'Go anonymous',
            onPressed: _signInAnonymously,
            buttonColor: Colors.lime.shade300,
            icon: Icon(FontAwesomeIcons.glasses),
          ),
        ],
      ),
    );
  }
}
