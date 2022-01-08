import 'package:flutter/material.dart';
import 'package:unit/constants.dart';

class ModalBottomSheetHeader extends StatelessWidget {
  const ModalBottomSheetHeader({
    Key key,
    this.title,
    this.sizedBoxWidth,
  }) : super(key: key);

  final String title;
  final double sizedBoxWidth;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(
          left: size.width * 0.02,
          right: size.width * 0.02,
          bottom: size.height * 0.01),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: size.height * 0.001,
            color: kPrimaryLightColor,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: size.width * 0.05, color: kPrimaryTextColor),
          ),
          SizedBox(width: size.width * sizedBoxWidth),
          IconButton(
            icon: Icon(
              Icons.close,
              color: kPrimaryTextColor,
              size: size.width * 0.085,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
