import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unit/components/lists_cards/locations_list_select.dart';
import 'package:unit/models/location.dart';
import 'package:unit/services/auth.dart';
import 'package:unit/services/database.dart';
import 'package:unit/constants.dart';
import 'package:unit/translations/locale_keys.g.dart';

class SelectDistrict extends StatefulWidget {
  static const id = 'SelectDistrict';
  final Function toggleView;
  SelectDistrict({this.toggleView});
  @override
  _SelectDistrictState createState() => _SelectDistrictState();
}

class _SelectDistrictState extends State<SelectDistrict> {
  AuthService _auth = AuthService();

  // text field state
  String district = '';
  String governate = '';
  List<String> districts = [];
  String error = '';
  bool loading = false;
  int selectedTab = 0;
  Map governateData = {};

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    governateData = ModalRoute.of(context).settings.arguments;
    Size size = MediaQuery.of(context).size;

    return StreamProvider<List<Location>>.value(
      value: DatabaseService().getDistricts(governateData['govName']),
      builder: (context, child) {
        return SafeArea(
          child: Scaffold(
            body: Column(
              children: [
                Container(
                  child: Row(
                    children: [
                      BackButton(
                        color: kSecondaryColor,
                      ),
                      Text(
                        tr(LocaleKeys.city),
                        style: TextStyle(
                          color: kPrimaryTextColor,
                          fontSize: size.height * 0.03,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Expanded(
                  child: SelectLocationList('', governateData['govName'], '',
                      governateData['govNameAr'], '', governateData['addType']),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
