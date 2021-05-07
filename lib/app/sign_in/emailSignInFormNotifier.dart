import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quiztoyou/app/sign_in/emailSignInModelNotifier.dart';
import 'package:quiztoyou/app/sign_in/formButton.dart';
import 'package:quiztoyou/common_widgets/dialog.dart';
import 'package:quiztoyou/services/auth.dart';

class EmailSignInFormNotifier extends StatefulWidget {
  EmailSignInFormNotifier({Key? key, required this.model}) : super(key: key);
  final EmailSignInModelNotifier model;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<EmailSignInModelNotifier>(
      create: (_) => EmailSignInModelNotifier(auth: auth),
      child: Consumer<EmailSignInModelNotifier>(
        builder: (_, model, __) => EmailSignInFormNotifier(model: model),
      ),
    );
  }

  @override
  _EmailSignInFormNotifierState createState() =>
      _EmailSignInFormNotifierState();
}

class _EmailSignInFormNotifierState extends State<EmailSignInFormNotifier> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passFocusNode = FocusNode();
  EmailSignInModelNotifier get model => widget.model;

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    super.dispose();
  }

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
      await model.submit();
      ProgressDialog.dissmiss(context);
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (err) {
      ProgressDialog.dissmiss(context);
      ShowExceptionDialog.alert(
        context: context,
        title: 'Form submitted Failed',
        exception: err,
      );
      print('Error ${err.toString()}');
    }
  }

  void _emailEditingComplete() {
    // Input text button to NEXT
    // If the email is not valid FOCUS keeps on EMAIL field
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  List<Widget> _buildChildren(Size size) {
    return [
      TextField(
        controller: _emailController,
        focusNode: _emailFocusNode,
        decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'test@test.com',
          errorText: model.emailErrorText,
          enabled: model.isLoading == false,
        ),
        autocorrect: false,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        onEditingComplete: () => _emailEditingComplete(),
        onChanged: model.updateEmail, // Value is implicit Passed
      ),
      TextField(
        controller: _passController,
        focusNode: _passFocusNode,
        decoration: InputDecoration(
          labelText: 'Password',
          errorText: model.passwordErrorText,
          enabled: model.isLoading == false,
        ),
        obscureText: true,
        textInputAction: TextInputAction.done,
        onChanged: (value) => model.updatePassword(value),
      ),
      SizedBox(
        height: 24,
      ),
      FormButton(
        onPressed: model.canSubmit ? this._submit : null,
        text: model.buttonText,
        textSize: 18,
      ),
      SizedBox(
        height: 8,
      ),
      TextButton(
        onPressed: !model.isLoading ? _toogleFormType : null,
        child: Text(
          model.adviceText,
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
    model.toogleFormType();
    _emailController.clear();
    _passController.clear();
  }
}
