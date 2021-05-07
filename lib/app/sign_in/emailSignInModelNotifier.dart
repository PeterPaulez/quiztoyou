import 'package:flutter/foundation.dart';
import 'package:quiztoyou/app/sign_in/validators.dart';
import 'package:quiztoyou/app/sign_in/emailSignInModel.dart';
import 'package:quiztoyou/services/auth.dart';

class EmailSignInModelNotifier with EmailAnPasswordValidators, ChangeNotifier {
  EmailSignInModelNotifier({
    required this.auth,
    this.email = '',
    this.password = '',
    this.formType = EmailFormType.signIn,
    this.isLoading = false,
    this.submittedForm = false,
  });
  final AuthBase auth;
  String email;
  String password;
  EmailFormType formType;
  bool isLoading;
  bool submittedForm;

  Future<void> submit() async {
    updateWith(submittedForm: true, isLoading: true);
    try {
      if (this.formType == EmailFormType.signIn) {
        await auth.signInEmail(this.email, this.password);
      } else {
        await auth.createUserWithEmail(this.email, this.password);
      }
    } catch (err) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  String get buttonText {
    return formType == EmailFormType.signIn ? 'Sign in' : 'Create an account';
  }

  String get adviceText {
    return formType == EmailFormType.signIn
        ? 'Need an account? Register!'
        : 'Have an account? Sign in!';
  }

  bool get canSubmit {
    return emailValidator.isValid(email) &&
        passwordValidator.isValid(password) &&
        !isLoading;
  }

  String? get passwordErrorText {
    bool showErrorText = submittedForm && !passwordValidator.isValid(password);
    return showErrorText ? invalidPasswordErrorText : null;
  }

  String? get emailErrorText {
    bool showErrorText = submittedForm && !emailValidator.isValid(email);
    return showErrorText ? invalidEmailErrorText : null;
  }

  void updateEmail(String value) => updateWith(email: value);

  void updatePassword(String value) => updateWith(password: value);

  void toogleFormType() {
    final formType = this.formType == EmailFormType.signIn
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
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.submittedForm = submittedForm ?? this.submittedForm;
    notifyListeners();
  }
}
