import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../constants.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    return Container(
      color: kPrimaryLightColor,
      child: Center(
        child: Lottie.asset('assets/animations/loading.json',
            width: size.width * 0.6),
      ),
    );
  }
}
