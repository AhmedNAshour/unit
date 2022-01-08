import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unit/components/lists_cards/users_list.dart';
import 'package:unit/constants.dart';
import 'package:unit/models/user.dart';
import 'package:unit/services/database.dart';

class Clients extends StatefulWidget {
  static const id = 'Clients';
  @override
  _ClientsState createState() => _ClientsState();
}

class _ClientsState extends State<Clients> {
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
                      'Clients',
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
                        value: DatabaseService().getUsersBySearch('client'),
                      ),
                    ],
                    child: UsersList(''),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
