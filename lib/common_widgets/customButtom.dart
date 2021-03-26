import 'package:flutter/material.dart';

class CustomButtom extends StatelessWidget {
  final Color buttonColor;
  final Color textColor;
  final double textSize;
  final String text;
  final double borderRadius;
  final VoidCallback onPressed;
  final Icon icon;
  CustomButtom({
    this.buttonColor: Colors.white,
    this.textColor: Colors.black87,
    this.textSize: 15.0,
    this.borderRadius: 6.0,
    @required this.icon,
    @required this.text,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return MaterialButton(
      splashColor: Colors.transparent,
      height: 48,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(this.borderRadius)),
      ),
      onPressed: this.onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: size.width * 0.2, child: this.icon),
          SizedBox(
            width: size.width * 0.6,
            child: Text(
              text,
              style: TextStyle(color: textColor, fontSize: textSize),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      color: this.buttonColor,
      disabledColor: Colors.grey,
    );
  }
}
