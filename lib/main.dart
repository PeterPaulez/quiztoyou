import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quiztoyou/app/sign_in/signInPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QuizToYou App',
      theme: ThemeData(primaryColor: Colors.pinkAccent),
      home: SignInPage(),
    );
  }
}
