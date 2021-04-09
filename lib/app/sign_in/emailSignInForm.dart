import 'package:flutter/material.dart';
import 'package:quiztoyou/app/sign_in/formButton.dart';

class EmailSignInForm extends StatefulWidget {
  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Card fit content as minimum
        children: _buildChildren(size),
      ),
    );
  }

  List<Widget> _buildChildren(Size size) {
    return [
      TextField(
        controller: _emailController,
        decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'test@test.com',
        ),
      ),
      TextField(
        controller: _passController,
        decoration: InputDecoration(
          labelText: 'Password',
        ),
        obscureText: true,
      ),
      SizedBox(
        height: 24,
      ),
      FormButton(
        onPressed: this._submitSignIn,
        text: 'Sign in',
      ),
      SizedBox(
        height: 8,
      ),
      TextButton(
        onPressed: () {},
        child: Text(
          'Need an account? Register here!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      ),
    ];
  }

  Future<void> _submitSignIn() async {
    print('Email: ${_emailController.text} :: Pass: ${_passController.text}');
  }
}
