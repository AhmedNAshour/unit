import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:unit/screens/admin/dataHandling_screen.dart';
import 'package:unit/screens/shared/favorites.dart';
import 'package:unit/screens/shared/home.dart';
import 'package:unit/constants.dart';
import 'package:unit/screens/shared/myProfile.dart';

class SalesmanNavigation extends StatefulWidget {
  @override
  _SalesmanNavigationState createState() => _SalesmanNavigationState();
}

class _SalesmanNavigationState extends State<SalesmanNavigation> {
  int _currentIndex = 0;
  List<Widget> screens = [
    Home(),
    Favorites(),
    DataHandling(),
    Profile(),
  ];
  @override
  Widget build(BuildContext context) {
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
            FaIcon(
              FontAwesomeIcons.heart,
              size: 30,
              color: kPrimaryColor,
            ),
            FaIcon(
              FontAwesomeIcons.list,
              size: 30,
              color: kPrimaryColor,
            ),
            FaIcon(
              FontAwesomeIcons.user,
              size: 30,
              color: kPrimaryColor,
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
