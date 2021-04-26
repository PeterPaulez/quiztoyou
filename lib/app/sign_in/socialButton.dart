import 'package:flutter/material.dart';
import 'package:quiztoyou/common_widgets/customButtom.dart';

class SocialButton extends CustomButtom {
  SocialButton({
    Color buttonColor: Colors.white,
    Color disabledColor: Colors.white,
    Color textColor: Colors.black87,
    double textSize: 15.0,
    required String text,
    required Icon icon,
    VoidCallback? onPressed,
    required Size size,
  }) : super(
          buttonColor: buttonColor,
          disabledColor: disabledColor,
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: size.width * 0.2, child: icon),
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
        );
}
