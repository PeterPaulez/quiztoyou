import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quiztoyou/app/sign_in/emailSignIn.dart';
import 'package:quiztoyou/app/sign_in/signInBloc.dart';
import 'package:quiztoyou/app/sign_in/socialButton.dart';
import 'package:quiztoyou/common_widgets/dialog.dart';
import 'package:quiztoyou/services/auth.dart';
import 'package:transitioner/transitioner.dart';

class SignInPage extends StatelessWidget {
  // Widget require BLOC
  static Widget create(BuildContext context) {
    return Provider<SignInBloc>(
      create: (_) => SignInBloc(),
      child: SignInPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bloc = Provider.of<SignInBloc>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        actions: [],
        title: Text('QuizToYou Sign-in'),
        elevation: 2.0,
      ),
      // StreamBuilder just in BODY because it would be the place what needs
      body: StreamBuilder<bool>(
        stream: bloc.isLoadingStream,
        initialData: false,
        builder: (context, snapshot) {
          return _builContent(size, context, snapshot.data!);
        },
      ),
      backgroundColor: Colors.grey[200],
    );
  }

  void _showSignInError(
      BuildContext context, Exception exception, SignInBloc bloc) {
    _signInFinish(context, bloc);
    if (exception is FirebaseAuthException &&
        exception.code == 'ERROR_ABORTED_BY_USER') {
      return;
    }
    ShowExceptionDialog.alert(
      context: context,
      title: 'SignIn Failed ',
      exception: exception,
    );
  }

  void _signInStarts(BuildContext context, SignInBloc bloc) {
    bloc.setIsLoading(true);
  }

  void _signInFinish(BuildContext context, SignInBloc bloc) {
    bloc.setIsLoading(false);
  }

  void _signInAnonymously(
      BuildContext context, AuthBase auth, SignInBloc bloc) async {
    _signInStarts(context, bloc);
    try {
      await auth.signInAnonymously();
      print('LogIn');
    } on Exception catch (exception) {
      _showSignInError(context, exception, bloc);
    }
  }

  void _signInGoogle(
      BuildContext context, AuthBase auth, SignInBloc bloc) async {
    _signInStarts(context, bloc);
    try {
      await auth.signInGoogle();
      print('LogIn');
    } on Exception catch (exception) {
      _showSignInError(context, exception, bloc);
    }
  }

  void _signInFacebook(
      BuildContext context, AuthBase auth, SignInBloc bloc) async {
    _signInStarts(context, bloc);
    try {
      await auth.signInFacebook();
      print('LogIn');
    } on Exception catch (exception) {
      _showSignInError(context, exception, bloc);
    }
  }

  void _signInWithEmail(BuildContext context, AuthBase auth, SignInBloc bloc) {
    Transitioner(
      child: EmailSignInPage(),
      context: context,
      animation: AnimationType.slideRight,
      curveType: CurveType.decelerate,
    );
  }

  Widget _builContent(Size size, BuildContext context, bool isLoading) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final bloc = Provider.of<SignInBloc>(context, listen: false);
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 40,
            child: _buildHeaderText(isLoading),
          ),
          SizedBox(height: 48),
          SocialButton(
            size: size,
            text: 'Sign in with Google',
            onPressed:
                isLoading ? null : () => _signInGoogle(context, auth, bloc),
            icon: Icon(FontAwesomeIcons.google),
          ),
          SizedBox(height: 8),
          SocialButton(
            size: size,
            text: 'Sign in with Apple',
            textColor: Colors.white,
            buttonColor: Colors.black87,
            disabledColor: Colors.black87,
            onPressed: isLoading ? null : () {},
            icon: Icon(
              FontAwesomeIcons.apple,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          SocialButton(
            size: size,
            text: 'Sign in with Facebook',
            textColor: Colors.white,
            buttonColor: Color(0xFF333D92),
            disabledColor: Color(0xFF333D92),
            onPressed:
                isLoading ? null : () => _signInFacebook(context, auth, bloc),
            icon: Icon(
              FontAwesomeIcons.facebook,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          SocialButton(
            size: size,
            text: 'Sign in with Email',
            textColor: Colors.white,
            onPressed:
                isLoading ? null : () => _signInWithEmail(context, auth, bloc),
            buttonColor: Colors.teal.shade700,
            disabledColor: Colors.teal.shade700,
            icon: Icon(
              FontAwesomeIcons.mailBulk,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'or',
            style: TextStyle(fontSize: 14, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          SocialButton(
            size: size,
            text: 'Go anonymous',
            onPressed: isLoading
                ? null
                : () => _signInAnonymously(context, auth, bloc),
            buttonColor: Colors.lime.shade300,
            disabledColor: Colors.lime.shade300,
            icon: Icon(FontAwesomeIcons.glasses),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderText(bool isLoading) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Text(
      'Sign In',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
