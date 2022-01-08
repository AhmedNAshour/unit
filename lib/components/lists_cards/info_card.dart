import 'package:flutter/material.dart';
import '../../constants.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    Key key,
    this.title,
    this.body,
  }) : super(key: key);

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.08,
      width: size.width * 0.9,
      margin: EdgeInsets.only(top: size.height * 0.015),
      padding: EdgeInsets.all(size.width * 0.04),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: kPrimaryLightColor,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: kPrimaryTextColor,
              fontWeight: FontWeight.bold,
              fontSize: size.width * 0.05,
            ),
          ),
          Text(
            body,
            style: TextStyle(
              color: kPrimaryTextColor,
              fontSize: size.width * 0.05,
              fontWeight: FontWeight.w100,
            ),
          ),
        ],
      ),
    );
  }
}
