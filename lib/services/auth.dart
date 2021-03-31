import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthBase {
  // Implemented by AuthFireBase, doesn't need any sync option
  User? get currentUser;
  Future<User> signInAnonymously();
  Future<void> signOut();
}

class AuthFireBase implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<User> signInAnonymously() async {
    final userCredential = await _firebaseAuth.signInAnonymously();
    return userCredential.user!;
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
