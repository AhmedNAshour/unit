import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:unit/components/lists_cards/users_list.dart';
import 'package:unit/constants.dart';
import 'package:unit/models/user.dart';
import 'package:unit/screens/admin/admin_addSalesman_screen.dart';
import 'package:unit/services/database.dart';

class Salesmen extends StatefulWidget {
  static const id = 'Salesmen';
  @override
  _SalesmenState createState() => _SalesmenState();
}

class _SalesmenState extends State<Salesmen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Row(
                  children: [
                    BackButton(
                      color: kSecondaryColor,
                    ),
                    Text(
                      'Salesmen',
                      style: TextStyle(
                        color: kPrimaryTextColor,
                        fontSize: size.height * 0.03,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.02),
              Expanded(
                child: Container(
                  child: MultiProvider(
                    providers: [
                      StreamProvider<List<UserData>>.value(
                        value: DatabaseService().getUsersBySearch('salesman'),
                      ),
                    ],
                    child: UsersList(''),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: kSecondaryColor,
          onPressed: () {
            Navigator.pushNamed(context, AdminAddSalesman.id);
          },
          child: Icon(
            FontAwesomeIcons.plus,
          ),
        ),
      ),
    );
  }
}
