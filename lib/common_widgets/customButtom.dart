import 'package:flutter/material.dart';

class CustomButtom extends StatelessWidget {
  final Color buttonColor;
  final Color textColor;
  final double textSize;
  final String text;
  final double borderRadius;
  final VoidCallback onPressed;
  final Widget child;
  CustomButtom({
    this.buttonColor: Colors.white,
    this.textColor: Colors.black87,
    this.textSize: 15.0,
    this.borderRadius: 6.0,
    @required this.text,
    @required this.onPressed,
    @required this.child,
  }) : assert(text != null);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      splashColor: Colors.transparent,
      height: 48,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(this.borderRadius)),
      ),
      onPressed: this.onPressed,
      child: this.child,
      color: this.buttonColor,
      disabledColor: Colors.grey,
    );
  }
}
