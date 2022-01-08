import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unit/components/lists_cards/locations_list_select.dart';
import 'package:unit/models/location.dart';
import 'package:unit/services/database.dart';
import 'package:unit/constants.dart';
import 'package:unit/translations/locale_keys.g.dart';

class SelectArea extends StatefulWidget {
  static const id = 'SelectArea';
  final Function toggleView;
  SelectArea({this.toggleView});
  @override
  _SelectAreaState createState() => _SelectAreaState();
}

class _SelectAreaState extends State<SelectArea> {
  // text field state
  String district = '';
  String governate = '';
  String area = '';
  List<String> districts = [];
  String error = '';
  bool loading = false;
  int selectedTab = 0;
  Map data = {};

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    Size size = MediaQuery.of(context).size;

    return StreamProvider<List<Location>>.value(
      value: DatabaseService().getAreas(data['govName'], data['districtName']),
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
                        tr(LocaleKeys.district),
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
                  child: SelectLocationList(
                    '',
                    data['govName'],
                    data['districtName'],
                    data['govNameAr'],
                    data['districtNameAr'],
                    data['addType'],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
