import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:unit/components/forms/rounded_button..dart';
import 'package:unit/components/forms/rounded_input_field.dart';
import 'package:unit/components/lists_cards/locations-list.dart';
import 'package:unit/models/location.dart';
import 'package:unit/services/database.dart';
import 'package:unit/constants.dart';

class AdminAddArea extends StatefulWidget {
  static const id = 'Areas';
  final Function toggleView;
  AdminAddArea({this.toggleView});
  @override
  _AdminAddAreaState createState() => _AdminAddAreaState();
}

class _AdminAddAreaState extends State<AdminAddArea> {
  // text field state
  String district = '';
  String governate = '';
  String area = '';
  String areaAr = '';

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
                        'Areas in ${data['districtName']}',
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
                  child: LocationList('', ''),
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
                                        'Add Area',
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
                                              hintText: 'Area',
                                              onChanged: (val) {
                                                setState(() => area = val);
                                              },
                                              validator: (val) => val.isEmpty
                                                  ? 'Enter an area'
                                                  : null,
                                            ),
                                            RoundedInputField(
                                              obsecureText: false,
                                              icon: Icons.flag,
                                              hintText: 'Area Arabic',
                                              onChanged: (val) {
                                                setState(() => areaAr = val);
                                              },
                                              validator: (val) => val.isEmpty
                                                  ? 'Enter an area'
                                                  : null,
                                            ),
                                            RoundedButton(
                                              text: 'Add Area',
                                              press: () async {
                                                if (_formKey.currentState
                                                    .validate()) {
                                                  dynamic result;
                                                  result = await DatabaseService()
                                                      .updateLocationDataArea(
                                                          govName:
                                                              data['govName'],
                                                          districtName: data[
                                                              'districtName'],
                                                          areaName: area,
                                                          nameAr: areaAr);
                                                  Navigator.pop(context);
                                                  if (result == null) {
                                                    setState(() {
                                                      error = 'add area failed';
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
