import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class TextDialog {
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
