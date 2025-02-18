import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  final String? text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final double height;

  const TitleText(
      {Key? key,
      this.text,
      this.fontSize = 18,
      this.color = Colors.black,
      this.fontWeight = FontWeight.normal,
      this.textAlign = TextAlign.center,
      this.height = 1.5})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(text!,
        style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color,
            height: height),
        textAlign: textAlign);
  }
}
