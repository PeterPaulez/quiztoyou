import 'package:quiztoyou/app/sign_in/validators.dart';

enum EmailFormType { signIn, register }

class EmailSignInModel with EmailAnPasswordValidators {
  EmailSignInModel({
    this.email = '',
    this.password = '',
    this.formType = EmailFormType.signIn,
    this.isLoading = false,
    this.submittedForm = false,
  });
  final String email;
  final String password;
  final EmailFormType formType;
  final bool isLoading;
  final bool submittedForm;

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

  EmailSignInModel copyWith({
    String? email,
    String? password,
    EmailFormType? formType,
    bool? isLoading,
    bool? submittedForm,
  }) {
    return EmailSignInModel(
      email: email ?? this.email,
      password: password ?? this.password,
      formType: formType ?? this.formType,
      isLoading: isLoading ?? this.isLoading,
      submittedForm: submittedForm ?? this.submittedForm,
    );
  }
}
