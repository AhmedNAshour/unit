import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:unit/components/forms/compound_filtering_form.dart';
import 'package:unit/components/forms/rounded_input_field.dart';
import 'package:unit/components/lists_cards/compoundsList.dart';
import 'package:unit/constants.dart';
import 'package:unit/models/compound.dart';
import 'package:unit/models/user.dart';
import 'package:unit/screens/admin/selectLocation_governate.dart';
import 'package:unit/services/database.dart';
import 'package:unit/translations/locale_keys.g.dart';

class CompoundsSearch extends StatefulWidget {
  static const id = 'CompoundsSearch';
  @override
  _CompoundsSearchState createState() => _CompoundsSearchState();
}

class _CompoundsSearchState extends State<CompoundsSearch> {
  String governateFilter = '';
  String districtFilter = '';
  String search = '';
  Map navigationData = {};
  bool firstTime = true;

  changeGovernateFilter(newGovernateFilter) {
    setState(() {
      governateFilter = newGovernateFilter;
    });
  }

  changeDistrictFilter(newDistrictFilter) {
    setState(() {
      districtFilter = newDistrictFilter;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);
    navigationData = ModalRoute.of(context).settings.arguments;
    if (firstTime) districtFilter = navigationData['district'];
    if (firstTime) governateFilter = navigationData['governate'];
    firstTime = false;
    List filters = [
      governateFilter,
      districtFilter,
    ];

    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    return MultiProvider(
      providers: [
        StreamProvider<List<Compound>>.value(
          value: DatabaseService().getCompoundsBySearch(
            limited: false,
            governate: governateFilter,
            district: districtFilter,
            status: 'active',
            offer: navigationData['offer'],
          ),
        ),
        StreamProvider<UserData>.value(
            value:
                user != null ? DatabaseService(uid: user.uid).userData : null)
      ],
      child: SafeArea(
        child: Scaffold(
          // backgroundColor: Color(0xFFF0F0F0),
          body: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.04, vertical: height * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Header
                Row(
                  children: [
                    BackButton(
                      color: kSecondaryColor,
                    ),
                    Text(
                      tr(LocaleKeys.new_projects),
                      style: TextStyle(
                        color: kPrimaryTextColor,
                        fontSize: size.height * 0.03,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Container(
                  height: size.height * 0.06,
                  margin: EdgeInsets.only(bottom: size.height * 0.01),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: kPrimaryColor,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    decoration: InputDecoration(
                      // labelText: 'Bedrooms',
                      labelStyle: TextStyle(
                        color: kPrimaryColor,
                      ),
                      icon: Icon(
                        FontAwesomeIcons.search,
                      ),
                      hintText: tr(LocaleKeys.search_name),
                      focusColor: kPrimaryColor,

                      border: InputBorder.none,
                    ),
                    onChanged: (val) {
                      setState(() => search = val);
                    },
                  ),
                ),
                //Filtering
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0)),
                          ),
                          builder: (context) {
                            return StatefulBuilder(builder:
                                (BuildContext context,
                                    StateSetter insideState) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: size.height * 0.02,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: size.width * 0.02,
                                          right: size.width * 0.02,
                                          bottom: size.height * 0.01),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            width: size.height * 0.001,
                                            color: kPrimaryLightColor,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            tr(LocaleKeys.filter),
                                            style: TextStyle(
                                                fontSize: size.width * 0.05,
                                                color: kPrimaryTextColor),
                                          ),
                                          SizedBox(width: size.width * 0.28),
                                          IconButton(
                                            icon: Icon(
                                              Icons.close,
                                              color: kPrimaryTextColor,
                                              size: size.width * 0.085,
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.04,
                                      ),
                                      child: FilterCompoundsForm(
                                        changeGovernateFilter:
                                            changeGovernateFilter,
                                        changeDistrictFilter:
                                            changeDistrictFilter,
                                        districtFilter: districtFilter,
                                        governateFilter: governateFilter,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                          },
                          isScrollControlled: true,
                        );
                      },
                      child: Container(
                        height: height * 0.05,
                        width: width * 0.2,
                        decoration: BoxDecoration(
                          color: kSecondaryColor,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              FontAwesomeIcons.filter,
                              color: kPrimaryLightColor,
                              size: height * 0.025,
                            ),
                            Text(
                              tr(LocaleKeys.search),
                              style: TextStyle(
                                color: kPrimaryLightColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.05,
                    ),
                    Expanded(
                      child: Container(
                        height: height * 0.05,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: filters.length,
                          itemBuilder: (context, index) {
                            return filters[index] != null &&
                                    filters[index] != ''
                                ? Container(
                                    margin:
                                        EdgeInsets.only(right: width * 0.02),
                                    padding: EdgeInsets.all(width * 0.02),
                                    height: height * 0.05,
                                    decoration: BoxDecoration(
                                      color: kPrimaryLightColor,
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                        color: kPrimaryTextColor,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          filters[index].toString(),
                                          style: TextStyle(
                                            color: kPrimaryTextColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          width: width * 0.02,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (index == 0) {
                                                governateFilter = '';
                                                districtFilter = '';
                                              } else if (index == 1) {
                                                districtFilter = '';
                                              }
                                            });
                                          },
                                          child: Icon(
                                            FontAwesomeIcons.minusCircle,
                                            color: kSecondaryColor,
                                            size: width * 0.05,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Expanded(
                  child: Container(
                    child: CompoundsList(search, Axis.vertical),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: StreamBuilder<UserData>(
              stream:
                  user != null ? DatabaseService(uid: user.uid).userData : null,
              builder: (context, snapshot) {
                UserData userData = snapshot.data;
                if (snapshot.hasData) {
                  return userData.role == 'admin'
                      ? FloatingActionButton(
                          backgroundColor: kSecondaryColor,
                          onPressed: () {
                            Navigator.pushNamed(context, SelectGovernate.id,
                                arguments: {
                                  'type': 'compound',
                                });
                          },
                          child: Icon(
                            FontAwesomeIcons.plus,
                          ),
                        )
                      : Container();
                } else {
                  return Container();
                }
              }),
        ),
      ),
    );
  }
}
