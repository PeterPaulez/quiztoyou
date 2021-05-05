import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quiztoyou/app/sign_in/emailSignInPage.dart';
import 'package:quiztoyou/app/sign_in/signInBloc.dart';
import 'package:quiztoyou/app/sign_in/socialButton.dart';
import 'package:quiztoyou/common_widgets/dialog.dart';
import 'package:quiztoyou/services/auth.dart';
import 'package:transitioner/transitioner.dart';

class SignInPage extends StatelessWidget {
  final SignInBloc bloc;
  const SignInPage({Key? key, required this.bloc}) : super(key: key);

  // Widget require BLOC
  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<SignInBloc>(
      create: (_) => SignInBloc(auth: auth),
      // GLUE holds an provider and widget together
      child: Consumer<SignInBloc>(
        builder: (_, bloc, __) => SignInPage(bloc: bloc),
      ),
      dispose: (_, bloc) => bloc.dispose(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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

  void _showSignInError(BuildContext context, Exception exception) {
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

  void _signInAnonymously(BuildContext context) async {
    try {
      await bloc.signInAnonymously();
      print('LogIn');
    } on Exception catch (exception) {
      _showSignInError(context, exception);
    }
  }

  void _signInGoogle(BuildContext context) async {
    try {
      await bloc.signInGoogle();
      print('LogIn');
    } on Exception catch (exception) {
      _showSignInError(context, exception);
    }
  }

  void _signInFacebook(BuildContext context) async {
    try {
      await bloc.signInFacebook();
      print('LogIn');
    } on Exception catch (exception) {
      _showSignInError(context, exception);
    }
  }

  void _signInWithEmail(BuildContext context, AuthBase auth) {
    Transitioner(
      child: EmailSignInPage(),
      context: context,
      animation: AnimationType.slideRight,
      curveType: CurveType.decelerate,
    );
  }

  Widget _builContent(Size size, BuildContext context, bool isLoading) {
    final auth = Provider.of<AuthBase>(context, listen: false);
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
            onPressed: isLoading ? null : () => _signInGoogle(context),
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
            onPressed: isLoading ? null : () => _signInFacebook(context),
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
            onPressed: isLoading ? null : () => _signInWithEmail(context, auth),
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
            onPressed: isLoading ? null : () => _signInAnonymously(context),
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
