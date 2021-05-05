enum EmailFormType { signIn, register }

class EmailSignInModel {
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
