import 'dart:async';

import 'package:quiztoyou/app/sign_in/emailSignInModel.dart';
import 'package:quiztoyou/services/auth.dart';

class EmailSignInBloc {
  EmailSignInBloc({required this.auth});
  final AuthBase auth;
  final StreamController<EmailSignInModel> _modelController =
      StreamController<EmailSignInModel>();

  Stream<EmailSignInModel> get modelStream => _modelController.stream;
  EmailSignInModel _model = EmailSignInModel();

  void dispose() {
    _modelController.close();
  }

  Future<void> submit() async {
    updateWith(submittedForm: true, isLoading: true);
    print('Email: ${_model.email} :: Pass: ${_model.password}');
    //ProgressDialog.show(context);
    try {
      //await Future.delayed(Duration(seconds: 2)); // Test Dialog
      if (_model.formType == EmailFormType.signIn) {
        await auth.signInEmail(_model.email, _model.password);
      } else {
        await auth.createUserWithEmail(_model.email, _model.password);
      }
      //ProgressDialog.dissmiss(context);
      //Navigator.of(context).pop();
    } catch (err) {
      /*
      ProgressDialog.dissmiss(context);
      ShowExceptionDialog.alert(
        context: context,
        title: 'Form submitted Failed',
        exception: err,
      );
      */
      print('Error ${err.toString()}');
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void updateWith({
    String? email,
    String? password,
    EmailFormType? formType,
    bool? isLoading,
    bool? submittedForm,
  }) {
    _model = _model.copyWith(
      email: email!,
      password: password!,
      formType: formType!,
      isLoading: isLoading!,
      submittedForm: submittedForm!,
    );
    // Update all model at the same time
    _modelController.add(_model);
  }
}
