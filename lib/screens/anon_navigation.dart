import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:unit/screens/shared/contact_us.dart';
import 'package:unit/screens/shared/home.dart';
import 'package:unit/constants.dart';

class AnonNavigation extends StatefulWidget {
  @override
  _AnonNavigationState createState() => _AnonNavigationState();
}

class _AnonNavigationState extends State<AnonNavigation> {
  int _currentIndex = 0;
  List<Widget> screens = [
    Home(),
    ContactUs(),
  ];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Color(0xFFF0F0F0),
        body: screens[_currentIndex],
        bottomNavigationBar: CurvedNavigationBar(
          color: kPrimaryLightColor,
          backgroundColor: Colors.transparent,
          animationDuration: Duration(milliseconds: 200),
          height: 60,
          index: 0,
          items: [
            FaIcon(
              FontAwesomeIcons.home,
              size: 30,
              color: kPrimaryColor,
            ),
            SvgPicture.asset(
              'assets/images/UB.svg',
              width: size.width * 0.15,
            ),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
