import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiztoyou/app/landing.dart';
import 'package:quiztoyou/services/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      // It's not possible to pass Abstract class
      create: (context) => AuthFireBase(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'QuizToYou App',
        theme: ThemeData(primaryColor: Colors.pinkAccent),
        darkTheme: ThemeData(primaryColor: Colors.deepPurpleAccent),
        home: LandingPage(),
      ),
    );
  }
}
