import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:apple_sign_in_safety/apple_sign_in.dart';

abstract class AuthBase {
  // Implemented by AuthFireBase, doesn't need any sync option
  User? get currentUser;
  Future<User> signInAnonymously();
  Future<User?> signInEmail(String email, String password);
  Future<User?> createUserWithEmail(String email, String password);
  Stream<User?> authStateChanges();
  Future<User?> signInGoogle();
  Future<User?> signInFacebook();
  Future<User?> signInApple();
  Future<void> signOut();
}

class AuthFireBase implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<User> signInAnonymously() async {
    final userCredential = await _firebaseAuth.signInAnonymously();
    return userCredential.user!;
  }

  @override
  Future<User?> signInEmail(String email, String password) async {
    final userCredendial = await _firebaseAuth.signInWithCredential(
      EmailAuthProvider.credential(
        email: email,
        password: password,
      ),
    );
    return userCredendial.user;
  }

  @override
  Future<User?> createUserWithEmail(String email, String password) async {
    final userCredendial = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredendial.user;
  }

  @override
  Future<User?> signInGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null) {
        final userCredential = await _firebaseAuth
            .signInWithCredential(GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ));
        return userCredential.user!;
      } else {
        throw FirebaseAuthException(
          code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
          message: 'Missing Google ID Token',
        );
      }
    } else {
      throw FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  @override
  Future<User?> signInFacebook() async {
    final fb = FacebookLogin();
    final response = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);
    switch (response.status) {
      case FacebookLoginStatus.success:
        final accessToken = response.accessToken!;
        final userCredential = await _firebaseAuth.signInWithCredential(
          FacebookAuthProvider.credential(accessToken.token),
        );
        return userCredential.user;
      case FacebookLoginStatus.cancel:
        throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      case FacebookLoginStatus.error:
        throw FirebaseAuthException(
          code: 'ERROR_FACEBOOK_LOGIN_FAILED',
          message: response.error?.developerMessage,
        );
    }
  }

  @override
  Future<User?> signInApple({List<Scope> scopes = const []}) async {
    scopes = [Scope.email, Scope.fullName];
    final AuthorizationResult result = await AppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)]);
    switch (result.status) {
      case AuthorizationStatus.authorized:
        final appleIdCredential = result.credential!;
        final oAuthProvider = OAuthProvider('apple.com');
        final idToken = String.fromCharCodes(appleIdCredential.identityToken!);
        final accessToken =
            String.fromCharCodes(appleIdCredential.authorizationCode!);
        final credential = oAuthProvider.credential(
          idToken: idToken,
          accessToken: accessToken,
        );

        final authResult = await _firebaseAuth.signInWithCredential(credential);
        print(authResult);
        final firebaseUser = authResult.user;
        if (scopes.contains(Scope.fullName)) {
          final String displayName =
              '${appleIdCredential.fullName!.givenName} ${appleIdCredential.fullName!.familyName}';
          print(displayName);
          //await firebaseUser.updateProfile(displayName: displayName);
        }
        return firebaseUser!;
      case AuthorizationStatus.error:
        throw PlatformException(
          code: 'ERROR_AUTHORIZATION_DENIED',
          message: result.error.toString(),
        );
      case AuthorizationStatus.cancelled:
        throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
    }
  }

  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final facebookSignIn = FacebookLogin();
    await facebookSignIn.logOut();
    await _firebaseAuth.signOut();
  }
}
