import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiztoyou/app/sign_in/formButton.dart';
import 'package:quiztoyou/common_widgets/dialog.dart';
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
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passFocusNode = FocusNode();
  EmailFormType _formType = EmailFormType.signIn;
  String get _email => _emailController.text;
  String get _password => _passController.text;

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

  Future<void> _submit() async {
    print('Email: ${_emailController.text} :: Pass: ${_passController.text}');
    ProgressDialog.show(context);
    try {
      if (_formType == EmailFormType.signIn) {
        await widget.auth.signInEmail(_email, _password);
      } else {
        await widget.auth.createUserWithEmail(_email, _password);
      }
      ProgressDialog.dissmiss(context);
      Navigator.of(context).pop();
    } catch (err) {
      ProgressDialog.dissmiss(context);
      TextDialog.alert(
        context,
        title: 'Error',
        content: err.toString(),
      );
      print('Error ${err.toString()}');
    }
  }

  void _emailEditingComplete() {
    FocusScope.of(context).requestFocus(_passFocusNode);
  }

  List<Widget> _buildChildren(Size size) {
    final buttonText =
        (_formType == EmailFormType.signIn) ? 'Sign in' : 'Create an account';
    final adviceText = (_formType == EmailFormType.signIn)
        ? 'Need an account? Register!'
        : 'Have an account? Sign in!';
    bool submitEnabled = _email.isNotEmpty && _password.isNotEmpty;
    return [
      TextField(
        controller: _emailController,
        focusNode: _emailFocusNode,
        decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'test@test.com',
        ),
        autocorrect: false,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        onEditingComplete: _emailEditingComplete,
        onChanged: (value) {
          setState(() {});
        },
      ),
      TextField(
        controller: _passController,
        focusNode: _passFocusNode,
        decoration: InputDecoration(
          labelText: 'Password',
        ),
        obscureText: true,
        textInputAction: TextInputAction.done,
        onChanged: (value) {
          setState(() {});
        },
      ),
      SizedBox(
        height: 24,
      ),
      FormButton(
        onPressed: submitEnabled ? this._submit : null,
        text: buttonText,
        textSize: 18,
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
