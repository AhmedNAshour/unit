import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unit/models/location.dart';
import 'package:unit/models/user.dart';
import 'package:unit/screens/admin/admin_navigation.dart';
import 'package:unit/screens/anon_navigation.dart';
import 'package:unit/screens/client/client_navigation.dart';
import 'package:unit/screens/salesman/salesman_navigation.dart';
import 'package:unit/screens/shared/loading.dart';
import 'package:unit/services/database.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

bool loading = true;

class _WrapperState extends State<Wrapper> {
  String role = '';
  bool loading;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);

    if (user == null) {
      return AnonNavigation();
    } else {
      return MultiProvider(
        providers: [
          StreamProvider<UserData>.value(
              value: DatabaseService(uid: user.uid).userData),
          StreamProvider<List<Location>>.value(
              value: DatabaseService(uid: user.uid).governates),
        ],
        child: FutureBuilder(
          future: DatabaseService(uid: user.uid).getUserRole(),
          builder: (context, role) {
            if (!role.hasData) {
              return Loading();
            } else {
              if (role.data == 'admin') {
                return AdminNavigation();
              } else if (role.data == 'salesman') {
                return SalesmanNavigation();
              } else {
                return ClientNavigation();
              }
            }
          },
        ),
      );
    }
  }
}
