import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unit/components/lists_cards/locations_list_select.dart';
import 'package:unit/models/location.dart';
import 'package:unit/services/database.dart';
import 'package:unit/constants.dart';
import 'package:unit/translations/locale_keys.g.dart';

class SelectGovernate extends StatefulWidget {
  static const id = 'SelectGovernate';
  final Function toggleView;
  SelectGovernate({this.toggleView});
  @override
  _SelectGovernateState createState() => _SelectGovernateState();
}

class _SelectGovernateState extends State<SelectGovernate> {
  // text field state
  String district = '';
  String disctrictChoice = '';
  String governate = '';
  String governateChoice = '';
  String area = '';
  List<String> districts = [];
  List<Location> governates = [];
  String error = '';
  bool loading = false;
  int selectedTab = 0;
  Map addType = {};

  @override
  Widget build(BuildContext context) {
    addType = ModalRoute.of(context).settings.arguments;
    Size size = MediaQuery.of(context).size;

    return StreamProvider<List<Location>>.value(
      value: DatabaseService().governates,
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
                        tr(LocaleKeys.governorate),
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
                  child:
                      SelectLocationList('', '', '', '', '', addType['type']),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
