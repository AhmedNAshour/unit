import 'package:flutter/material.dart';
import 'package:unit/constants.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key key,
    @required this.press,
    this.text,
    this.color = kPrimaryColor,
    this.textColor = kPrimaryLightColor,
  }) : super(key: key);

  final Function press;
  final String text;
  final Color color, textColor;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: FlatButton(
          onPressed: press,
          child: Text(
            text,
            style: TextStyle(color: textColor, fontSize: 20),
          ),
          color: color,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        ),
      ),
    );
  }
}
