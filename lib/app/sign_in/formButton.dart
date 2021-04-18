import 'package:flutter/material.dart';
import 'package:quiztoyou/common_widgets/customButtom.dart';

class FormButton extends CustomButtom {
  FormButton({
    Color buttonColor: Colors.pink,
    Color textColor: Colors.white,
    double textSize: 16.0,
    required String text,
    required VoidCallback? onPressed,
  }) : super(
          buttonColor: buttonColor,
          onPressed: onPressed,
          child: Center(
            child: Text(
              text,
              style: TextStyle(color: textColor, fontSize: textSize),
            ),
          ),
        );
}
