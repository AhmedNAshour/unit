import 'package:flutter/material.dart';
import 'package:unit/constants.dart';
import 'package:easy_localization/easy_localization.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: kPrimaryColor,
          ),
        ),
        height: 40,
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              context.locale == Locale('en')
                  ? Icons.arrow_back
                  : Icons.arrow_forward,
              color: kPrimaryColor,
            ),
            Text(
              'BACK',
              style: TextStyle(
                  color: kPrimaryLightColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
