import 'package:flutter/material.dart';
import 'package:quiztoyou/app/sign_in/formButton.dart';
import 'package:quiztoyou/services/auth.dart';

enum EmailFormType { signIn, register }

class EmailSignInForm extends StatefulWidget {
  EmailSignInForm({required this.auth});
  final AuthBase auth;
  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  EmailFormType _formType = EmailFormType.signIn;

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
    final buttonText =
        (_formType == EmailFormType.signIn) ? 'Sign in' : 'Create an account';
    final adviceText = (_formType == EmailFormType.signIn)
        ? 'Need an account? Register!'
        : 'Have an account? Sign in!';
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
        text: buttonText,
      ),
      SizedBox(
        height: 8,
      ),
      TextButton(
        onPressed: _toogleFormType,
        child: Text(
          adviceText,
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

  void _toogleFormType() {
    setState(() {
      _formType = (_formType == EmailFormType.signIn)
          ? EmailFormType.register
          : EmailFormType.signIn;
      _emailController.clear();
      _passController.clear();
    });
  }
}
