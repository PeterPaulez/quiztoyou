import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiztoyou/services/auth.dart';

class SignInManager {
  SignInManager({required this.isLoading, required this.auth});
  final AuthBase auth;
  final ValueNotifier<bool> isLoading;

  Future<User?> _signIn(Future<User?> Function() sigInMethod) async {
    try {
      isLoading.value = true;
      return await sigInMethod();
    } catch (e) {
      isLoading.value = false;
    }
  }

  Future<User?> signInAnonymously() async =>
      await _signIn(auth.signInAnonymously);
  Future<User?> signInGoogle() async => await _signIn(auth.signInFacebook);
  Future<User?> signInFacebook() async =>
      await _signIn(() => auth.signInFacebook());
}
