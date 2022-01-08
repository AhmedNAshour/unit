import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unit/components/forms/rounded_button..dart';
import 'package:unit/constants.dart';
import 'package:unit/models/user.dart';
import 'package:unit/screens/shared/clients.dart';
import 'package:unit/screens/shared/compounds_search.dart';
import 'package:unit/screens/shared/listings.dart';
import 'package:unit/screens/shared/salesmen.dart';
import 'admin_addLocation_governate.dart';

class DataHandling extends StatefulWidget {
  @override
  _DataHandlingState createState() => _DataHandlingState();
}

class _DataHandlingState extends State<DataHandling> {
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);
    Size size = MediaQuery.of(context).size;
    double height = size.height;

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RoundedButton(
                  color: kPrimaryColor,
                  text: 'Properties',
                  press: () {
                    Navigator.pushNamed(context, Listings.id);
                  }),
              SizedBox(height: size.height * 0.02),
              RoundedButton(
                  color: kPrimaryColor,
                  text: 'Compounds',
                  press: () {
                    Navigator.pushNamed(context, CompoundsSearch.id,
                        arguments: {
                          'district': '',
                        });
                  }),
              SizedBox(height: size.height * 0.02),
              RoundedButton(
                  color: kPrimaryColor,
                  text: 'Locations',
                  press: () {
                    Navigator.pushNamed(context, AdminAddGovernate.id);
                  }),
              SizedBox(height: size.height * 0.02),
              userData.role == 'admin'
                  ? RoundedButton(
                      color: kPrimaryColor,
                      text: 'Salesmen',
                      press: () {
                        Navigator.pushNamed(context, Salesmen.id);
                      })
                  : Container(),
              SizedBox(height: size.height * 0.02),
              userData.role == 'admin'
                  ? RoundedButton(
                      color: kPrimaryColor,
                      text: 'Clients',
                      press: () {
                        Navigator.pushNamed(context, Clients.id);
                      })
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
