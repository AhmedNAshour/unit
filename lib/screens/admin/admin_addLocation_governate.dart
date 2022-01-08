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

class AdminAddGovernate extends StatefulWidget {
  static const id = 'Governates';
  final Function toggleView;
  AdminAddGovernate({this.toggleView});
  @override
  _AdminAddGovernateState createState() => _AdminAddGovernateState();
}

class _AdminAddGovernateState extends State<AdminAddGovernate> {
  AuthService _auth = AuthService();

  // text field state
  String district = '';
  String disctrictChoice = '';
  String governate = '';
  String governateAr = '';
  String governateChoice = '';
  String area = '';
  List<String> districts = [];
  List<Location> governates = [];
  String error = '';
  bool loading = false;
  int selectedTab = 0;

  final _formKey = GlobalKey<FormState>();

  // List<Widget> tabs = [
  //   AddGovernate(),
  //   AddDistrict(),
  //   AddArea(),
  // ];

  @override
  Widget build(BuildContext context) {
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
                        'Governates',
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
                                        'Add Governate',
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
                                              hintText: 'Governate',
                                              onChanged: (val) {
                                                setState(() => governate = val);
                                              },
                                              validator: (val) => val.isEmpty
                                                  ? 'Enter a governate'
                                                  : null,
                                            ),
                                            RoundedInputField(
                                              obsecureText: false,
                                              icon: Icons.flag,
                                              hintText: 'Governate Arabic',
                                              onChanged: (val) {
                                                setState(
                                                    () => governateAr = val);
                                              },
                                              validator: (val) => val.isEmpty
                                                  ? 'Enter a governate'
                                                  : null,
                                            ),
                                            RoundedButton(
                                              text: 'Add Governate',
                                              press: () async {
                                                if (_formKey.currentState
                                                    .validate()) {
                                                  dynamic result;

                                                  result =
                                                      await DatabaseService()
                                                          .updateLocationData(
                                                              govName:
                                                                  governate,
                                                              nameAr:
                                                                  governateAr);
                                                  Navigator.pop(context);
                                                  if (result == null) {
                                                    setState(() {
                                                      error =
                                                          'add governate failed';
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

// StreamBuilder<List<Location>>(
//             stream: DatabaseService().governates,
//             builder: (context, snapshot) {
//               if (snapshot.hasData) {
//                 governates = snapshot.data;
//                 print('Governates: ' + governates.toString());
//                 return Scaffold(
//                   body: Column(
//                     children: [
//                       Expanded(child: LocationList('')),
//                     ],
//                   ),
//                 );
//               } else {
//                 return Loading();
//               }
//             });
// Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           BackButton(),
//                           SizedBox(
//                             height: size.height * 0.02,
//                           ),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     setState(() {
//                                       selectedTab = 0;
//                                     });
//                                   },
//                                   child: Container(
//                                     child: Text(
//                                       'Governate',
//                                       style: TextStyle(
//                                         color: kPrimaryColor,
//                                         fontSize: size.width * 0.05,
//                                       ),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     setState(() {
//                                       selectedTab = 1;
//                                     });
//                                   },
//                                   child: Container(
//                                     child: Text(
//                                       'District',
//                                       style: TextStyle(
//                                         color: kPrimaryColor,
//                                         fontSize: size.width * 0.05,
//                                       ),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     setState(() {
//                                       selectedTab = 2;
//                                     });
//                                   },
//                                   child: Container(
//                                     child: Text(
//                                       'Area',
//                                       style: TextStyle(
//                                         color: kPrimaryColor,
//                                         fontSize: size.width * 0.05,
//                                       ),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(
//                             height: size.height * 0.1,
//                           ),
//                           Center(child: tabs[selectedTab]),
//                           Container(
//                             child: SingleChildScrollView(
//                               child: Form(
//                                 key: _formKey,
//                                 child: Column(
//                                   children: [
//                                     SmartSelect<String>.single(
//                                       title: 'Governates',
//                                       value: governate,
//                                       choiceItems:
//                                           S2Choice.listFrom<String, String>(
//                                         source: governates,
//                                         value: (index, item) => item,
//                                         title: (index, item) => item,
//                                       ),
//                                       onChange: (state) => setState(() {
//                                         governate = state.value;
//                                       }),
//                                       modalType: S2ModalType.popupDialog,
//                                       choiceType: S2ChoiceType.chips,
//                                     ),
//                                     Container(
//                                       height: 60,
//                                       width: double.infinity,
//                                       padding: EdgeInsets.symmetric(
//                                           horizontal: 20, vertical: 5),
//                                       decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         borderRadius: BorderRadius.circular(29),
//                                       ),
//                                       child: DropdownButtonFormField(
//                                         decoration: InputDecoration(
//                                           border: InputBorder.none,
//                                         ),
//                                         icon: Icon(
//                                           Icons.pin_drop,
//                                           color: kPrimaryColor,
//                                         ),
//                                         hint: Text(
//                                           'Choose branch',
//                                         ),

//                                         // value: selectedName ??
//                                         //     branches[0],
//                                         items: districts.map((district) {
//                                           return DropdownMenuItem(
//                                             value: district,
//                                             child: Text(district),
//                                           );
//                                         }).toList(),
//                                         onChanged: (val) => setState(
//                                             () => disctrictChoice = val),
//                                       ),
//                                     ),
//                                     RoundedInputField(
//                                       obsecureText: false,
//                                       icon: Icons.flag,
//                                       hintText: 'Area',
//                                       onChanged: (val) {
//                                         setState(() => area = val);
//                                       },
//                                       validator: (val) =>
//                                           val.isEmpty ? 'Enter an area' : null,
//                                     ),
//                                     RoundedButton(
//                                       text: 'Add Area',
//                                       press: () async {
//                                         if (_formKey.currentState.validate()) {
//                                           dynamic result;

//                                           result = await DatabaseService()
//                                               .updateLocationDataArea(
//                                                   areaName: area,
//                                                   districtName: district,
//                                                   govName: governate);
//                                           if (result == Null) {
//                                             setState(() {
//                                               error = 'add district failed';
//                                               loading = false;
//                                             });
//                                           } else {
//                                             setState(() {
//                                               loading = false;
//                                             });
//                                           }
//                                         }
//                                       },
//                                     ),
//                                     SizedBox(
//                                       height: 10,
//                                     ),
//                                     Text(
//                                       error,
//                                       style: TextStyle(
//                                           color: Colors.red, fontSize: 14),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
