import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class TextDialog {
  static alert(BuildContext context,
      {required String title, required String content}) {
    showDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          MaterialButton(
            onPressed: () => Navigator.pop(_),
            child: Text('OK'),
          )
        ],
      ),
    );
  }
}

abstract class ProgressDialog {
  static show(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (_) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white.withOpacity(0.9),
            child: Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }

  static dissmiss(BuildContext context) {
    Navigator.pop(context);
  }
}
