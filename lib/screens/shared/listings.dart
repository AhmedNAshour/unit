import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:unit/components/lists_cards/propertiesList.dart';
import 'package:unit/components/lists_cards/propertiesList_admin.dart';
import 'package:unit/components/loginSingupModalBottomSheet.dart';
import 'package:unit/constants.dart';
import 'package:unit/models/property.dart';
import 'package:unit/models/user.dart';
import 'package:unit/screens/admin/selectLocation_governate.dart';
import 'package:unit/screens/shared/loading.dart';
import 'package:unit/services/database.dart';

class Listings extends StatefulWidget {
  static const id = 'Listings';
  @override
  _ListingsState createState() => _ListingsState();
}

class _ListingsState extends State<Listings> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;

    MyUser user = Provider.of<MyUser>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
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
                            userData.role == 'admin'
                                ? BackButton(
                                    color: kSecondaryColor,
                                  )
                                : Container(),
                            Text(
                              'My Properties',
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
                              StreamProvider<List<Property>>.value(
                                value: DatabaseService().getPropertiesBySearch(
                                    limited: false, agentId: user.uid),
                              ),
                              StreamProvider<UserData>.value(
                                value: DatabaseService(uid: user.uid).userData,
                              ),
                            ],
                            child: userData != null
                                ? userData.role == 'admin'
                                    ? PropertiesListAdmin('', Axis.vertical)
                                    : PropertiesList('', Axis.vertical)
                                : PropertiesList('', Axis.vertical),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.endFloat,
                floatingActionButton: FloatingActionButton(
                  backgroundColor: kSecondaryColor,
                  onPressed: () {
                    if (user != null) {
                      Navigator.pushNamed(context, SelectGovernate.id,
                          arguments: {
                            'type': 'resale',
                          });
                    } else {
                      showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0)),
                        ),
                        builder: (context) {
                          return FractionallySizedBox(
                            heightFactor: 0.9,
                            child: DraggableScrollableSheet(
                              initialChildSize: 1.0,
                              maxChildSize: 1.0,
                              minChildSize: 0.25,
                              builder: (BuildContext context,
                                  ScrollController scrollController) {
                                return StatefulBuilder(builder:
                                    (BuildContext context,
                                        StateSetter insideState) {
                                  return LoginSignupModalBottomSheet(
                                    modalBottomSheetState: insideState,
                                  );
                                });
                              },
                            ),
                          );
                        },
                        isScrollControlled: true,
                      );
                    }
                  },
                  child: Icon(
                    FontAwesomeIcons.plus,
                  ),
                ),
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
