import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
        title: Text('QuizToYou Sign-in'),
        elevation: 2.0,
      ),
      body: _builContent(),
    );
  }

  Widget _builContent() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            color: Colors.orange,
            child: SizedBox(
              height: 100,
              width: double.infinity,
            ),
          ),
          SizedBox(height: 8),
          Container(
            color: Colors.red,
            child: SizedBox(
              height: 100,
              width: double.infinity,
            ),
          ),
          SizedBox(height: 8),
          Container(
            color: Colors.purple,
            child: SizedBox(
              height: 100,
              width: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}
