import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:unit/components/forms/rounded_button..dart';
import 'package:unit/translations/locale_keys.g.dart';
import '../../constants.dart';

class Added extends StatelessWidget {
  Added(this.type);
  final String type;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Container(
          // color: kPrimaryLightColor,
          child: Center(
            child: Column(
              children: [
                //TODO: edit design
                Lottie.asset('assets/animations/check.json', repeat: false),
                Text(
                  // '$type Added',
                  tr(LocaleKeys.unit_added),
                  textAlign: TextAlign.center,

                  style: TextStyle(
                    fontSize: size.width * 0.1,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  // '$type Added',
                  tr(LocaleKeys.will_review_ad),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: size.width * 0.05,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                RoundedButton(
                    color: Colors.white,
                    textColor: kPrimaryColor,
                    text: tr(LocaleKeys.home),
                    press: () {
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
