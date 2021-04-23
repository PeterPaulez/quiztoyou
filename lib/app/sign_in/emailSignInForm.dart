import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quiztoyou/app/sign_in/formButton.dart';
import 'package:quiztoyou/app/sign_in/validators.dart';
import 'package:quiztoyou/common_widgets/dialog.dart';
import 'package:quiztoyou/services/auth.dart';

enum EmailFormType { signIn, register }

class EmailSignInForm extends StatefulWidget with EmailAnPasswordValidators {
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
  bool _submittedForm = false;
  bool _isLoading = false;

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
    final auth = Provider.of<AuthBase>(context, listen: false);
    setState(() {
      _submittedForm = true;
      // With the Dialog is not need but its a good idea to block and disabled everything in
      // the form once you submit it: inputs, button and link are disabled
      _isLoading = true;
    });
    print('Email: ${_emailController.text} :: Pass: ${_passController.text}');
    ProgressDialog.show(context);
    try {
      //await Future.delayed(Duration(seconds: 2)); // Test Dialog
      if (_formType == EmailFormType.signIn) {
        await auth.signInEmail(_email, _password);
      } else {
        await auth.createUserWithEmail(_email, _password);
      }
      ProgressDialog.dissmiss(context);
      Navigator.of(context).pop();
    } catch (err) {
      ProgressDialog.dissmiss(context);
      TextDialog.alert(
        context,
        title: 'Form submit Failed',
        content: err.toString(),
        textOK: 'Ok',
      );
      print('Error ${err.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _emailEditingComplete() {
    // Input text button to NEXT
    // If the email is not valid FOCUS keeps on EMAIL field
    final newFocus = widget.emailValidator.isValid(_email)
        ? _passFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  List<Widget> _buildChildren(Size size) {
    final buttonText =
        (_formType == EmailFormType.signIn) ? 'Sign in' : 'Create an account';
    final adviceText = (_formType == EmailFormType.signIn)
        ? 'Need an account? Register!'
        : 'Have an account? Sign in!';
    bool emailValid = widget.emailValidator.isValid(_email);
    bool passwordValid = widget.passwordValidator.isValid(_password);
    bool submitEnabled = emailValid && passwordValid && !_isLoading;

    return [
      TextField(
        controller: _emailController,
        focusNode: _emailFocusNode,
        decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'test@test.com',
          errorText: (!emailValid && _submittedForm)
              ? widget.invalidEmailErrorText
              : null,
          enabled: _isLoading == false,
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
          errorText: (!passwordValid && _submittedForm)
              ? widget.invalidPasswordErrorText
              : null,
          enabled: _isLoading == false,
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
        onPressed: !_isLoading ? _toogleFormType : null,
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
      _submittedForm = false;
      _formType = (_formType == EmailFormType.signIn)
          ? EmailFormType.register
          : EmailFormType.signIn;
      _emailController.clear();
      _passController.clear();
    });
  }
}
