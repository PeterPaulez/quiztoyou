import 'package:flutter/material.dart';

class CustomButtom extends StatelessWidget {
  final Color buttonColor;
  final double borderRadius;
  final VoidCallback? onPressed;
  final Widget child;
  final double elevation;
  final double height;
  CustomButtom({
    this.buttonColor: Colors.white,
    this.borderRadius: 6.0,
    this.elevation: 5,
    this.height: 48,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      splashColor: Colors.transparent,
      height: this.height,
      elevation: this.elevation,
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
