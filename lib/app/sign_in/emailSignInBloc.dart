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
    try {
      if (_model.formType == EmailFormType.signIn) {
        await auth.signInEmail(_model.email, _model.password);
      } else {
        await auth.createUserWithEmail(_model.email, _model.password);
      }
    } catch (err) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void updateEmail(String value) => updateWith(email: value);

  void updatePassword(String value) => updateWith(password: value);

  void toogleFormType() {
    final formType = _model.formType == EmailFormType.signIn
        ? EmailFormType.register
        : EmailFormType.signIn;
    updateWith(
      email: '',
      password: '',
      isLoading: false,
      submittedForm: false,
      formType: formType,
    );
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
