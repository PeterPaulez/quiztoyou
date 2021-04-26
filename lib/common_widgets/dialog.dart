import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextDialog {
  static alert(
    BuildContext context, {
    required String title,
    required String content,
    required String textOK,
    String? textNOK,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          if (textNOK != null)
            MaterialButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(textNOK),
            ),
          MaterialButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(textOK),
          )
        ],
      ),
    );
  }
}

class ShowExceptionDialog {
  static alert({
    required BuildContext context,
    required String title,
    required Exception exception,
  }) =>
      TextDialog.alert(
        context,
        title: title,
        content: _message(exception),
        textOK: 'OK',
      );
  static String _message(Exception exception) {
    if (exception is FirebaseException) {
      return '\n' + exception.message!;
    }
    return '\n' + exception.toString();
  }
}

class ProgressDialog {
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
