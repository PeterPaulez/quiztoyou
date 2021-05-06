import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quiztoyou/app/sign_in/emailSignInBloc.dart';
import 'package:quiztoyou/app/sign_in/emailSignInModel.dart';
import 'package:quiztoyou/app/sign_in/formButton.dart';
import 'package:quiztoyou/app/sign_in/validators.dart';
import 'package:quiztoyou/common_widgets/dialog.dart';
import 'package:quiztoyou/services/auth.dart';

class EmailSignInFormBloc extends StatefulWidget
    with EmailAnPasswordValidators {
  EmailSignInFormBloc({Key? key, required this.bloc}) : super(key: key);
  final EmailSignInBloc bloc;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<EmailSignInBloc>(
      create: (_) => EmailSignInBloc(auth: auth),
      child: Consumer<EmailSignInBloc>(
        builder: (_, bloc, __) => EmailSignInFormBloc(bloc: bloc),
      ),
      dispose: (_, bloc) => bloc.dispose(),
    );
  }

  @override
  _EmailSignInFormBlocState createState() => _EmailSignInFormBlocState();
}

class _EmailSignInFormBlocState extends State<EmailSignInFormBloc> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passFocusNode = FocusNode();

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
    return StreamBuilder<EmailSignInModel>(
      stream: widget.bloc.modelStream,
      initialData: EmailSignInModel(),
      builder: (context, snapshot) {
        final EmailSignInModel? model = snapshot.data;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Card fit content as minimum
            children: _buildChildren(size, model!),
          ),
        );
      },
    );
  }

  Future<void> _submit() async {
    print('Email: ${_emailController.text} :: Pass: ${_passController.text}');
    ProgressDialog.show(context);
    try {
      await widget.bloc.submit();
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

  void _emailEditingComplete(EmailSignInModel model) {
    // Input text button to NEXT
    // If the email is not valid FOCUS keeps on EMAIL field
    final newFocus = widget.emailValidator.isValid(model.email)
        ? _passFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  List<Widget> _buildChildren(Size size, EmailSignInModel model) {
    final buttonText = (model.formType == EmailFormType.signIn)
        ? 'Sign in'
        : 'Create an account';
    final adviceText = (model.formType == EmailFormType.signIn)
        ? 'Need an account? Register!'
        : 'Have an account? Sign in!';
    bool emailValid = widget.emailValidator.isValid(model.email);
    bool passwordValid = widget.passwordValidator.isValid(model.password);
    bool submitEnabled = emailValid && passwordValid && !model.isLoading;

    return [
      TextField(
        controller: _emailController,
        focusNode: _emailFocusNode,
        decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'test@test.com',
          errorText: (!emailValid && model.submittedForm)
              ? widget.invalidEmailErrorText
              : null,
          enabled: model.isLoading == false,
        ),
        autocorrect: false,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        onEditingComplete: () => _emailEditingComplete(model),
        onChanged: widget.bloc.updateEmail, // Value is implicit Passed
      ),
      TextField(
        controller: _passController,
        focusNode: _passFocusNode,
        decoration: InputDecoration(
          labelText: 'Password',
          errorText: (!passwordValid && model.submittedForm)
              ? widget.invalidPasswordErrorText
              : null,
          enabled: model.isLoading == false,
        ),
        obscureText: true,
        textInputAction: TextInputAction.done,
        onChanged: (value) => widget.bloc.updateEmail(value),
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
        onPressed: !model.isLoading ? _toogleFormType : null,
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
    widget.bloc.toogleFormType();
    _emailController.clear();
    _passController.clear();
  }
}
