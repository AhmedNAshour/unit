import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:unit/components/forms/rounded_button..dart';
import 'package:unit/components/forms/rounded_input_field.dart';

import 'package:unit/components/lists_cards/locations-list.dart';
import 'package:unit/models/location.dart';
import 'package:unit/services/auth.dart';
import 'package:unit/services/database.dart';
import 'package:unit/constants.dart';

class AdminAddDistrict extends StatefulWidget {
  static const id = 'Districts';
  final Function toggleView;
  AdminAddDistrict({this.toggleView});
  @override
  _AdminAddDistrictState createState() => _AdminAddDistrictState();
}

class _AdminAddDistrictState extends State<AdminAddDistrict> {
  AuthService _auth = AuthService();

  // text field state
  String district = '';
  String districtAr = '';
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
                        'Districts in ${governateData['govName']}',
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
                  child: LocationList('', governateData['govName']),
                )
              ],
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(
                FontAwesomeIcons.plus,
              ),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return FractionallySizedBox(
                        heightFactor: 0.7,
                        child: DraggableScrollableSheet(
                            initialChildSize: 1.0,
                            maxChildSize: 1.0,
                            minChildSize: 0.25,
                            builder: (BuildContext context,
                                ScrollController scrollController) {
                              return SingleChildScrollView(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 40),
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        'Add District',
                                        style: TextStyle(
                                          color: kPrimaryColor,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Form(
                                        key: _formKey,
                                        child: Column(
                                          children: [
                                            RoundedInputField(
                                              obsecureText: false,
                                              icon: Icons.flag,
                                              hintText: 'District',
                                              onChanged: (val) {
                                                setState(() => district = val);
                                              },
                                              validator: (val) => val.isEmpty
                                                  ? 'Enter a district'
                                                  : null,
                                            ),
                                            RoundedInputField(
                                              obsecureText: false,
                                              icon: Icons.flag,
                                              hintText: 'District Arabic',
                                              onChanged: (val) {
                                                setState(
                                                    () => districtAr = val);
                                              },
                                              validator: (val) => val.isEmpty
                                                  ? 'Enter a district'
                                                  : null,
                                            ),
                                            RoundedButton(
                                              text: 'Add District',
                                              press: () async {
                                                if (_formKey.currentState
                                                    .validate()) {
                                                  dynamic result;

                                                  result = await DatabaseService()
                                                      .updateLocationDataDistrict(
                                                          govName:
                                                              governateData[
                                                                  'govName'],
                                                          districtName:
                                                              district,
                                                          nameAr: districtAr);
                                                  Navigator.pop(context);
                                                  if (result == null) {
                                                    setState(() {
                                                      error =
                                                          'add district failed';
                                                      loading = false;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      loading = false;
                                                    });
                                                  }
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      );
                    },
                    isScrollControlled: true);
              },
            ),
          ),
        );
      },
    );
  }
}
